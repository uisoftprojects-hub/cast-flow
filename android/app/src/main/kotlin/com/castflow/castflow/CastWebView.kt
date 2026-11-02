package com.castflow.castflow

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.view.View
import android.webkit.CookieManager
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.json.JSONObject
import java.util.Collections

class CastWebViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView =
        CastWebView(context, messenger, viewId, (args as? Map<*, *>)?.get("url") as? String)
}

/**
 * Browser WebView with video detection. Candidates come from two places and
 * are merged on the Dart side:
 *  - network: shouldInterceptRequest sees every sub-resource request
 *    (manifests, media files, range requests from <video>);
 *  - DOM: an injected script reports <video>/<source> elements, and a
 *    MutationObserver catches ones added later, via [Bridge].
 * Each report carries the page token so results from a previous page are
 * dropped after navigation.
 */
@SuppressLint("SetJavaScriptEnabled")
class CastWebView(context: Context, messenger: BinaryMessenger, id: Int, initialUrl: String?) : PlatformView {
    private val main = Handler(Looper.getMainLooper())
    private val channel = MethodChannel(messenger, "castflow/webview_$id")
    private val webView = WebView(context)
    private val reported = Collections.synchronizedSet(HashSet<String>())

    @Volatile private var token = 0
    @Volatile private var pageUrl = ""
    private val userAgent: String

    init {
        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            mediaPlaybackRequiresUserGesture = true
            loadWithOverviewMode = true
            useWideViewPort = true
            builtInZoomControls = true
            displayZoomControls = false
            setSupportMultipleWindows(false)
        }
        userAgent = webView.settings.userAgentString
        CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true)
        webView.addJavascriptInterface(Bridge(), "CastFlowBridge")
        webView.webViewClient = Client()
        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView, newProgress: Int) {
                send("progress", mapOf("value" to newProgress))
            }

            override fun onReceivedTitle(view: WebView, title: String?) {
                send("title", mapOf("title" to (title ?: ""), "token" to token))
            }
        }
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "loadUrl" -> webView.loadUrl(call.argument<String>("url") ?: "about:blank")
                "back" -> if (webView.canGoBack()) webView.goBack()
                "forward" -> if (webView.canGoForward()) webView.goForward()
                "reload" -> webView.reload()
                "stop" -> webView.stopLoading()
                "pauseVideos" -> webView.evaluateJavascript(PAUSE_JS, null)
                "rescan" -> webView.evaluateJavascript("window.__castflow&&window.__castflow.reset();", null)
                else -> {
                    result.notImplemented(); return@setMethodCallHandler
                }
            }
            result.success(null)
        }
        initialUrl?.let { webView.loadUrl(it) }
    }

    override fun getView(): View = webView

    override fun dispose() {
        channel.setMethodCallHandler(null)
        webView.stopLoading()
        webView.removeJavascriptInterface("CastFlowBridge")
        webView.destroy()
    }

    private fun send(method: String, args: Map<String, Any?>) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            channel.invokeMethod(method, args)
        } else {
            main.post { channel.invokeMethod(method, args) }
        }
    }

    /** A new page (or SPA route): new token, fresh list on both sides. */
    private fun navigated(url: String, force: Boolean = false) {
        if (!force && strip(url) == strip(pageUrl)) return
        pageUrl = url
        token++
        reported.clear()
        send(
            "navigated",
            mapOf(
                "url" to url,
                "token" to token,
                "canGoBack" to webView.canGoBack(),
                "canGoForward" to webView.canGoForward(),
            )
        )
    }

    private fun strip(url: String) = url.substringBefore('#')

    /** Headers the TV needs to fetch [url] the way the page did. */
    private fun headersFor(url: String, request: Map<String, String>? = null): Map<String, String> {
        val h = HashMap<String, String>()
        request?.forEach { (k, v) ->
            if (k.equals("Referer", true) || k.equals("User-Agent", true) || k.equals("Origin", true)) h[k] = v
        }
        if (h.keys.none { it.equals("User-Agent", true) }) h["User-Agent"] = userAgent
        if (h.keys.none { it.equals("Referer", true) } && pageUrl.isNotEmpty()) h["Referer"] = pageUrl
        try {
            CookieManager.getInstance().getCookie(url)?.let { if (it.isNotEmpty()) h["Cookie"] = it }
        } catch (_: Exception) {
        }
        return h
    }

    private fun inject(view: WebView) = view.evaluateJavascript(DETECT_JS, null)

    private inner class Client : WebViewClient() {
        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
            navigated(url, force = true) // includes reloads
            inject(view)
        }

        override fun onPageFinished(view: WebView, url: String) {
            send("finished", mapOf("url" to url, "title" to (view.title ?: ""), "token" to token))
            inject(view)
        }

        override fun doUpdateVisitedHistory(view: WebView, url: String?, isReload: Boolean) {
            if (url != null) navigated(url)
            send("history", mapOf("canGoBack" to view.canGoBack(), "canGoForward" to view.canGoForward()))
        }

        // Only web pages load in the browser; app links (intent:, market:) are ignored.
        override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
            val scheme = request.url.scheme ?: return true
            return scheme != "http" && scheme != "https"
        }

        // Runs on a background thread. Never blocks or replaces the request.
        override fun shouldInterceptRequest(view: WebView, request: WebResourceRequest): WebResourceResponse? {
            if (request.isForMainFrame) return null
            val url = request.url.toString()
            val path = (request.url.path ?: "").lowercase()
            val lower = url.lowercase()
            if (request.method == "POST" && (lower.contains("widevine") || lower.contains("/license") || lower.contains("playready"))) {
                val t = token
                send("drm", mapOf("token" to t))
                return null
            }
            val byExtension = MEDIA_EXTENSIONS.any { path.endsWith(it) }
            // <video> elements fetch with a Range header; extension-less ones
            // are confirmed by content type on the Dart side.
            val ranged = request.requestHeaders.keys.any { it.equals("Range", true) } &&
                SKIP_EXTENSIONS.none { path.endsWith(it) }
            if (!byExtension && !ranged) return null
            if (!reported.add(url.substringBefore('#'))) return null
            send(
                "resource",
                mapOf(
                    "url" to url,
                    "token" to token,
                    "probe" to !byExtension,
                    "headers" to headersFor(url, request.requestHeaders),
                )
            )
            return null
        }
    }

    /** Called from the injected script (JavaBridge thread). */
    private inner class Bridge {
        @JavascriptInterface
        fun report(json: String) {
            if (json.length > 20_000) return
            val t = token
            try {
                val o = JSONObject(json)
                val url = o.optString("url")
                if (url.isEmpty()) return
                val map = HashMap<String, Any?>()
                map["url"] = url
                map["token"] = t
                map["poster"] = o.optString("poster").ifEmpty { null }
                map["title"] = o.optString("title").ifEmpty { null }
                map["duration"] = o.optDouble("duration").takeIf { !it.isNaN() && !it.isInfinite() }
                map["height"] = o.optInt("height", 0)
                map["drm"] = o.optBoolean("drm", false)
                map["image"] = o.optString("image").ifEmpty { null }
                map["headers"] = if (url.startsWith("http")) headersFor(url) else emptyMap<String, String>()
                send("dom", map)
            } catch (_: Exception) {
            }
        }

        @JavascriptInterface
        fun drm() {
            val t = token
            send("drm", mapOf("token" to t))
        }
    }

    companion object {
        private val MEDIA_EXTENSIONS = listOf(".m3u8", ".mpd", ".mp4", ".m4v", ".webm", ".mkv", ".mov")
        private val SKIP_EXTENSIONS = listOf(
            ".ts", ".m4s", ".m4a", ".aac", ".mp3", ".js", ".css", ".json", ".png", ".jpg", ".jpeg",
            ".gif", ".webp", ".svg", ".woff", ".woff2", ".ttf", ".html", ".vtt", ".srt",
        )

        private const val PAUSE_JS =
            "(function(){try{document.querySelectorAll('video,audio').forEach(function(v){v.pause();});}catch(e){}})();"

        /**
         * Idempotent: a second injection only rescans. Everything is wrapped
         * in try/catch so a page's own scripts are never affected.
         */
        private val DETECT_JS = """
(function(){
  try {
    if (window.__castflow) { window.__castflow.scan(); return; }
    var B = window.CastFlowBridge; if (!B) return;
    var sent = {};
    function abs(u){ try { return u ? new URL(u, location.href).href : null; } catch(e){ return null; } }
    function image(){ var m = document.querySelector('meta[property="og:image"],meta[name="twitter:image"]'); return m ? abs(m.content) : null; }
    function report(v, src){
      var u = abs(src); if (!u) return;
      var d = v && isFinite(v.duration) ? v.duration : null;
      var key = u + '|' + (d ? Math.round(d) : '') + '|' + (v ? v.videoHeight : '');
      if (sent[key]) return; sent[key] = 1;
      B.report(JSON.stringify({
        url: u,
        poster: v && v.poster ? abs(v.poster) : null,
        duration: d,
        height: v ? (v.videoHeight || 0) : 0,
        title: (v && (v.getAttribute('title') || v.getAttribute('aria-label'))) || document.title,
        drm: !!(v && v.mediaKeys),
        image: image()
      }));
    }
    function check(v){
      try {
        var srcs = [v.currentSrc, v.src];
        var ss = v.querySelectorAll('source');
        for (var i = 0; i < ss.length; i++) srcs.push(ss[i].src);
        for (var j = 0; j < srcs.length; j++) if (srcs[j]) report(v, srcs[j]);
      } catch(e){}
    }
    function watch(v){
      if (!v.__castflow) {
        v.__castflow = 1;
        ['loadedmetadata','durationchange','play'].forEach(function(n){ v.addEventListener(n, function(){ check(v); }, {passive: true}); });
        v.addEventListener('encrypted', function(){ try { B.drm(); } catch(e){} }, {passive: true});
      }
      check(v);
    }
    function scan(){ try { var vs = document.querySelectorAll('video'); for (var i = 0; i < vs.length; i++) watch(vs[i]); } catch(e){} }
    var timer = null;
    var mo = new MutationObserver(function(){ if (timer) return; timer = setTimeout(function(){ timer = null; scan(); }, 400); });
    function start(){
      scan();
      try { mo.observe(document.documentElement || document, {childList: true, subtree: true, attributes: true, attributeFilter: ['src']}); } catch(e){}
    }
    if (navigator.requestMediaKeySystemAccess && !navigator.__castflowDrm) {
      navigator.__castflowDrm = 1;
      var original = navigator.requestMediaKeySystemAccess;
      navigator.requestMediaKeySystemAccess = function(){ try { B.drm(); } catch(e){} return original.apply(navigator, arguments); };
    }
    window.__castflow = { scan: scan, reset: function(){ sent = {}; scan(); } };
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start); else start();
  } catch(e){}
})();
"""
    }
}
