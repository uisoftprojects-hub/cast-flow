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

        /** The cast icon drawn over a video on the page was tapped. */
        @JavascriptInterface
        fun castTap(json: String) {
            val t = token
            try {
                val url = JSONObject(json).optString("url")
                send("castTap", mapOf("url" to url, "token" to t))
            } catch (_: Exception) {
                send("castTap", mapOf("url" to "", "token" to t))
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
    function scan(){ try { var vs = document.querySelectorAll('video'); for (var i = 0; i < vs.length; i++) watch(vs[i]); } catch(e){} soon(); }
    // A round cast button drawn over every video on the page (not part of the page's own DOM
    // tree: one fixed layer that lets everything else through). Tapping it asks the app to cast.
    var ovRoot = null, tracked = [], raf = 0;
    var CAST_SVG = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="#ffffff"><path d="M1 18v3h3c0-1.66-1.34-3-3-3zm0-4v2c2.76 0 5 2.24 5 5h2c0-3.87-3.13-7-7-7zm0-4v2c4.97 0 9 4.03 9 9h2c0-6.08-4.93-11-11-11zm20-7H3c-1.1 0-2 .9-2 2v3h2V5h18v14h-7v2h7c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/></svg>';
    function layer(){
      if (ovRoot && ovRoot.isConnected) return ovRoot;
      ovRoot = document.createElement('div');
      ovRoot.setAttribute('data-castflow', '1');
      ovRoot.style.cssText = 'position:fixed;left:0;top:0;width:0;height:0;z-index:2147483647;pointer-events:none;';
      (document.body || document.documentElement).appendChild(ovRoot);
      return ovRoot;
    }
    function srcOf(v){
      var s = v.currentSrc || v.src || '';
      if (!s) { var so = v.querySelector('source'); if (so) s = so.src || ''; }
      return /^https?:/i.test(s) ? s : '';
    }
    function button(v){
      var b = v.__cfBtn;
      if (b && b.isConnected) return b;
      b = document.createElement('div');
      b.setAttribute('role', 'button');
      b.setAttribute('aria-label', 'Cast to TV');
      b.style.cssText = 'position:fixed;width:42px;height:42px;border-radius:21px;background:linear-gradient(135deg,#3B82F6,#1D4ED8);box-shadow:0 2px 10px rgba(0,0,0,.45);display:none;align-items:center;justify-content:center;pointer-events:auto;cursor:pointer;touch-action:manipulation;-webkit-tap-highlight-color:transparent;';
      b.innerHTML = CAST_SVG;
      // The page must not react to the tap (play/pause, navigation), so the touch events
      // are swallowed. That also stops the browser from sending the click that follows
      // a touch, so the cast is triggered on release (touch / pointer / mouse) and the
      // click only as a fallback; the guard makes one tap fire once.
      var eat = function(e){ try { e.preventDefault(); e.stopPropagation(); } catch(x){} };
      var fire = function(e){
        eat(e);
        var now = Date.now();
        if (b.__t && now - b.__t < 600) return;
        b.__t = now;
        try { B.castTap(JSON.stringify({url: srcOf(v)})); } catch(x){}
      };
      ['touchstart','pointerdown','mousedown','mouseup'].forEach(function(n){ b.addEventListener(n, eat, true); });
      ['touchend','pointerup','click'].forEach(function(n){ b.addEventListener(n, fire, true); });
      layer().appendChild(b);
      v.__cfBtn = b;
      tracked.push(v);
      return b;
    }
    function layout(){
      try {
        var vw = window.innerWidth, vh = window.innerHeight;
        var vs = document.querySelectorAll('video');
        for (var i = 0; i < vs.length; i++) {
          var v = vs[i], r = v.getBoundingClientRect();
          // Big enough to be the page's video, and on screen.
          var show = !document.hidden && r.width >= 160 && r.height >= 90 && r.bottom > 40 && r.top < vh - 40 && r.right > 40 && r.left < vw - 40;
          if (show) { var cs = getComputedStyle(v); show = cs.display !== 'none' && cs.visibility !== 'hidden' && cs.opacity !== '0'; }
          if (!show) { if (v.__cfBtn) v.__cfBtn.style.display = 'none'; continue; }
          var b = button(v);
          b.style.left = Math.max(8, Math.min(r.right, vw) - 52) + 'px';
          b.style.top = (Math.max(r.top, 0) + 8) + 'px';
          b.style.display = 'flex';
        }
        // Videos that were removed from the page take their button with them.
        for (var t = tracked.length - 1; t >= 0; t--) {
          var tv = tracked[t];
          if (!tv.isConnected) {
            if (tv.__cfBtn && tv.__cfBtn.parentNode) tv.__cfBtn.parentNode.removeChild(tv.__cfBtn);
            tracked.splice(t, 1);
          }
        }
      } catch(e){}
    }
    function soon(){ if (raf) return; raf = requestAnimationFrame(function(){ raf = 0; layout(); }); }
    var timer = null;
    var mo = new MutationObserver(function(){ if (timer) return; timer = setTimeout(function(){ timer = null; scan(); }, 400); });
    function start(){
      scan();
      try {
        window.addEventListener('scroll', soon, {passive: true, capture: true});
        window.addEventListener('resize', soon, {passive: true});
        window.addEventListener('orientationchange', soon, {passive: true});
        setInterval(soon, 600);
      } catch(e){}
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
