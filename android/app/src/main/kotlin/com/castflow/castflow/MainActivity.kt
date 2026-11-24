package com.castflow.castflow

import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.view.Display
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import com.google.android.gms.ads.nativead.AdChoicesView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.NativeAdFactory

/** Re-colours already-loaded native ads in place, so a theme change needs no new ad request. */
object NativeAdTheme {
    private val views = java.util.Collections.newSetFromMap(java.util.WeakHashMap<NativeAdView, Boolean>())

    fun register(view: NativeAdView) {
        synchronized(views) { views.add(view) }
    }

    fun apply(view: NativeAdView, dark: Boolean) {
        val isOnboarding = view.findViewById<View>(R.id.ad_choices) != null
        if (isOnboarding) {
            view.setBackgroundResource(if (dark) R.drawable.native_ad_bg_onboarding_dark else R.drawable.native_ad_bg_onboarding_light)
            view.findViewById<TextView>(R.id.ad_headline)
                ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#F4F5F8" else "#333333"))
            view.findViewById<TextView>(R.id.ad_body)
                ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#9CA3AF" else "#777777"))
        } else {
            view.setBackgroundResource(if (dark) R.drawable.native_ad_bg_dark else R.drawable.native_ad_bg_light)
            view.findViewById<TextView>(R.id.ad_headline)
                ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#F4F5F8" else "#202124"))
            view.findViewById<TextView>(R.id.ad_body)
                ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#9CA3AF" else "#777777"))
        }
    }

    fun setDark(dark: Boolean) {
        val snapshot = synchronized(views) { views.toList() }
        snapshot.forEach { apply(it, dark) }
    }
}

/** Measures how tall a bound native ad needs to be at a given width, so Flutter can size its container. */
object NativeAdSizer {
    private val views = java.util.concurrent.ConcurrentHashMap<String, java.lang.ref.WeakReference<NativeAdView>>()

    fun register(id: String?, view: NativeAdView) {
        if (id != null) views[id] = java.lang.ref.WeakReference(view)
    }

    /** Height in dp of the text column (title, description, CTA) for a full ad width of [widthDp]. */
    fun measureDp(id: String, widthDp: Double): Double? {
        val view = views[id]?.get() ?: return null
        val density = view.resources.displayMetrics.density
        // Video layout: the whole stacked content (media + info row + CTA) at full width.
        val content = view.findViewById<View>(R.id.ad_content_root)
        if (content != null) {
            val widthPx = (widthDp * density).toInt()
            if (widthPx <= 0) return null
            content.measure(
                View.MeasureSpec.makeMeasureSpec(widthPx, View.MeasureSpec.EXACTLY),
                View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
            )
            return content.measuredHeight / density.toDouble()
        }
        val column = view.findViewById<View>(R.id.ad_text_column) ?: return null
        val columnPx = (widthDp * density * 0.65).toInt()
        if (columnPx <= 0) return null
        column.measure(
            View.MeasureSpec.makeMeasureSpec(columnPx, View.MeasureSpec.EXACTLY),
            View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
        )
        return column.measuredHeight / density.toDouble()
    }
}

class CustomNativeAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    companion object {
        private const val TAG = "AdMob"
    }

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any>?
    ): NativeAdView {
        val isDark = customOptions?.get("isDark") as? Boolean ?: false
        Log.d(TAG, "[NativeAdFactory] STATE: INFLATING_LAYOUT | isDark: $isDark | headline: ${nativeAd.headline}")
        val layoutKind = customOptions?.get("layout") as? String
        val withMedia = layoutKind == "media"
        val onboarding = layoutKind == "onboarding"
        val layoutId = when {
            onboarding && isDark -> R.layout.custom_native_ad_onboarding_dark
            onboarding -> R.layout.custom_native_ad_onboarding
            withMedia && isDark -> R.layout.custom_native_ad_media_dark
            withMedia -> R.layout.custom_native_ad_media
            isDark -> R.layout.custom_native_ad_dark
            else -> R.layout.custom_native_ad
        }
        val nativeAdView = layoutInflater.inflate(layoutId, null) as NativeAdView

        if (withMedia) {
            val mediaContainer = nativeAdView.findViewById<View>(R.id.ad_media_container)
            val mediaView = nativeAdView.findViewById<MediaView>(R.id.ad_media)
            val content = nativeAd.mediaContent
            if (content != null) {
                mediaView.mediaContent = content
                mediaView.setImageScaleType(ImageView.ScaleType.CENTER_CROP)
                nativeAdView.mediaView = mediaView
                mediaContainer.visibility = View.VISIBLE
            } else {
                mediaContainer.visibility = View.GONE
            }
        }

        if (onboarding) {
            // ~138dp layout: Media (120dp x 120dp square, FIT_CENTER, 8dp rounded), AdChoices 22x22 in left gutter 34dp.
            val mediaContainer = nativeAdView.findViewById<View>(R.id.ad_media_container)
            val mediaView = nativeAdView.findViewById<MediaView>(R.id.ad_media)
            val content = nativeAd.mediaContent
            if (content != null) {
                mediaView.mediaContent = content
                mediaView.setImageScaleType(ImageView.ScaleType.FIT_CENTER)
                nativeAdView.mediaView = mediaView
                mediaContainer.visibility = View.VISIBLE
            } else {
                // Media na ho to media INVISIBLE ho jata hai.
                mediaContainer.visibility = View.INVISIBLE
            }
            nativeAdView.adChoicesView = nativeAdView.findViewById<AdChoicesView>(R.id.ad_choices)
        }

        val iconView = nativeAdView.findViewById<ImageView?>(R.id.ad_app_icon)
        val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
        val ctaView = nativeAdView.findViewById<Button>(R.id.ad_call_to_action)

        // The onboarding layout has no separate icon (the media takes that place).
        if (iconView != null) {
            nativeAd.icon?.let {
                iconView.setImageDrawable(it.drawable)
                iconView.visibility = View.VISIBLE
                nativeAdView.iconView = iconView
                Log.v(TAG, "[NativeAdFactory] STATE: ICON_BOUND")
            } ?: run {
                iconView.visibility = View.GONE
            }
        }

        headlineView.text = nativeAd.headline
        nativeAdView.headlineView = headlineView

        nativeAd.body?.let {
            bodyView.text = it
            bodyView.visibility = View.VISIBLE
            nativeAdView.bodyView = bodyView
            Log.v(TAG, "[NativeAdFactory] STATE: BODY_BOUND | text: $it")
        } ?: run {
            bodyView.visibility = View.GONE
        }

        nativeAd.callToAction?.let {
            ctaView.text = it
            ctaView.visibility = View.VISIBLE
            nativeAdView.callToActionView = ctaView
            Log.v(TAG, "[NativeAdFactory] STATE: CTA_BOUND | text: $it")
        } ?: run {
            ctaView.visibility = View.GONE
        }

        nativeAdView.setNativeAd(nativeAd)
        NativeAdTheme.register(nativeAdView)
        NativeAdSizer.register(nativeAd.responseInfo?.responseId, nativeAdView)
        Log.i(TAG, "[NativeAdFactory] STATE: NATIVE_AD_RENDERED | headline: ${nativeAd.headline}")
        return nativeAdView
    }
}

class MainActivity : FlutterActivity() {
    private var networkMonitor: NetworkMonitor? = null
    private var mediaConvert: MediaConvert? = null
    private val nativeAdFactoryId = "castflow_native_ad"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Back button / gesture does nothing while an interstitial or App Open ad is showing.
        AdBackBlocker.install(application)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.isStatusBarContrastEnforced = false
            window.isNavigationBarContrastEnforced = false
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register custom native ad factory with GoogleMobileAdsPlugin
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            nativeAdFactoryId,
            CustomNativeAdFactory(layoutInflater)
        )

        // AdMob configuration channel exposing native build-specific AdMob parameters
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/admob_config").setMethodCallHandler { call, result ->
            when (call.method) {
                "getAdConfig" -> {
                    result.success(
                        mapOf(
                            "isRelease" to !BuildConfig.DEBUG,
                            "appId" to getString(R.string.admob_app_id),
                            "appOpenId" to getString(R.string.admob_app_open_id),
                            "languageNativeId" to getString(R.string.admob_language_native_id),
                            "onboardingNativeId" to getString(R.string.admob_onboarding_native_id),
                            "splashInterstitialFirstId" to getString(R.string.admob_splash_interstitial_first_id),
                            "splashInterstitialSecondId" to getString(R.string.admob_splash_interstitial_second_id),
                            "clickInterstitialId" to getString(R.string.admob_click_interstitial_id),
                            "homeNativeId" to getString(R.string.admob_home_native_id),
                            // Legacy aliases for backward compatibility
                            "interstitialId" to getString(R.string.admob_interstitial_id),
                            "nativeId" to getString(R.string.admob_native_id)
                        )
                    )
                }
                else -> result.notImplemented()
            }
        }

        // Flutter tells us when a full-screen ad (interstitial / App Open) is on screen.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/ad_back_lock").setMethodCallHandler { call, result ->
            when (call.method) {
                "setLocked" -> {
                    AdBackBlocker.locked = call.argument<Boolean>("locked") ?: false
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Live theme switch for native ads that are already loaded (no re-request).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/native_ad_theme").setMethodCallHandler { call, result ->
            when (call.method) {
                "setDark" -> {
                    NativeAdTheme.setDark(call.argument<Boolean>("dark") ?: false)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Lets Flutter size the native ad container to its content (no clipping, no gaps).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/native_ad_size").setMethodCallHandler { call, result ->
            when (call.method) {
                "measure" -> {
                    val id = call.argument<String>("responseId")
                    val w = call.argument<Double>("widthDp")
                    result.success(if (id != null && w != null) NativeAdSizer.measureDp(id, w) else null)
                }
                else -> result.notImplemented()
            }
        }

        // Native Android Logcat channel for advertising state transitions
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/ad_logger").setMethodCallHandler { call, result ->
            when (call.method) {
                "log" -> {
                    val tag = call.argument<String>("tag") ?: "AdMob"
                    val level = call.argument<String>("level") ?: "DEBUG"
                    val message = call.argument<String>("message") ?: ""
                    when (level.uppercase()) {
                        "VERBOSE" -> Log.v(tag, message)
                        "DEBUG" -> Log.d(tag, message)
                        "INFO" -> Log.i(tag, message)
                        "WARN" -> Log.w(tag, message)
                        "ERROR" -> Log.e(tag, message)
                        else -> Log.d(tag, message)
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        flutterEngine.platformViewsController.registry
            .registerViewFactory("castflow/webview", CastWebViewFactory(flutterEngine.dartExecutor.binaryMessenger))
        val monitor = NetworkMonitor(applicationContext) { launch(it) }.also { networkMonitor = it }
        // Live Wi-Fi / hotspot changes (ConnectivityManager.NetworkCallback + AP state broadcast).
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/network_events").setStreamHandler(monitor)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/network").setMethodCallHandler { call, result ->
            when (call.method) {
                // Android filters incoming multicast unless a lock is held, which
                // breaks SSDP/mDNS TV discovery. Counted, see NetworkMonitor.
                "acquireMulticastLock" -> {
                    monitor.acquireMulticast()
                    result.success(true)
                }
                "releaseMulticastLock" -> {
                    monitor.releaseMulticast()
                    result.success(true)
                }
                // System cast / Smart View screen for screen mirroring.
                "openCastSettings" -> {
                    val opened = listOf(
                        Intent("android.settings.CAST_SETTINGS"),
                        Intent("com.samsung.android.smartmirroring.CAPTURE"),
                        Intent(Settings.ACTION_WIRELESS_SETTINGS),
                    ).any { intent -> launch(intent) }
                    result.success(opened)
                }
                // Wi-Fi (ConnectivityManager + LinkProperties) and own-hotspot state
                // (WifiManager reflection + AP network interface), with our address on each.
                "networkStatus" -> result.success(monitor.status())
                // Smart View / Cast screen mirroring adds a presentation display
                // while it runs; its name is the TV.
                "mirroringStatus" -> {
                    val dm = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
                    val display = dm.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)
                        .firstOrNull { it.displayId != Display.DEFAULT_DISPLAY }
                    result.success(mapOf("active" to (display != null), "name" to display?.name))
                }
                "openWifiSettings" -> result.success(launch(Intent(Settings.ACTION_WIFI_SETTINGS)))
                // Android 10+: the Wi-Fi panel slides over the app.
                "openWifiPanel" -> result.success(monitor.openWifiPanel())
                "openLocationSettings" -> result.success(launch(Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)))
                // Hotspot can't be enabled programmatically on modern Android, so
                // open the system tethering screen instead.
                "openHotspotSettings" -> result.success(monitor.openHotspotSettings())
                else -> result.notImplemented()
            }
        }

        // Runtime conversion of media the TV can't play (media3 Transformer / JPEG).
        val convertChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/media_convert")
        mediaConvert = MediaConvert(applicationContext, convertChannel).also { convertChannel.setMethodCallHandler(it) }

        // Keeps the process (and the media server the TV streams from) alive while casting.
        val sessionChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/cast_session")
        // Notification / lock screen buttons and seek bar -> Flutter.
        CastSessionBridge.onCommand = { name, positionMs ->
            runOnUiThread {
                sessionChannel.invokeMethod("command", mapOf("name" to name, "positionMs" to positionMs))
            }
        }
        sessionChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> result.success(CastSessionService.start(applicationContext, call.argument<String>("title")))
                // Title, play state, position and length for the notification and its seek bar.
                "update" -> {
                    CastSessionService.update(
                        CastSessionInfo(
                            title = call.argument<String>("title") ?: "",
                            subtitle = call.argument<String>("subtitle"),
                            playing = call.argument<Boolean>("playing") ?: false,
                            positionMs = (call.argument<Number>("positionMs") ?: 0).toLong(),
                            durationMs = (call.argument<Number>("durationMs") ?: 0).toLong(),
                            hasPrevious = call.argument<Boolean>("hasPrevious") ?: false,
                            hasNext = call.argument<Boolean>("hasNext") ?: false,
                            preparing = call.argument<Boolean>("preparing") ?: false,
                        )
                    )
                    result.success(true)
                }
                "stop" -> {
                    CastSessionService.stop(applicationContext)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, nativeAdFactoryId)
        CastSessionBridge.onCommand = null
        networkMonitor?.unregister()
        mediaConvert?.dispose()
        mediaConvert = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun launch(intent: Intent): Boolean = try {
        // Panels (Settings.Panel) must open in our task to float over the app.
        if (!intent.action.orEmpty().startsWith("android.settings.panel")) intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent); true
    } catch (_: Exception) {
        false
    }

    override fun onDestroy() {
        networkMonitor?.releaseAllMulticast()
        networkMonitor?.unregister()
        if (isFinishing) CastSessionService.stop(applicationContext)
        super.onDestroy()
    }
}
