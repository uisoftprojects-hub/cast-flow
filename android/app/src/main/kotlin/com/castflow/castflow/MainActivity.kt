package com.castflow.castflow

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.view.Display
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import java.net.Inet4Address
import java.net.NetworkInterface
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
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
        view.setBackgroundResource(if (dark) R.drawable.native_ad_bg_dark else R.drawable.native_ad_bg_light)
        view.findViewById<TextView>(R.id.ad_headline)
            ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#FFFFFF" else "#111827"))
        view.findViewById<TextView>(R.id.ad_body)
            ?.setTextColor(android.graphics.Color.parseColor(if (dark) "#9CA3AF" else "#6B7280"))
    }

    fun setDark(dark: Boolean) {
        val snapshot = synchronized(views) { views.toList() }
        snapshot.forEach { apply(it, dark) }
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
        val layoutId = if (isDark) R.layout.custom_native_ad_dark else R.layout.custom_native_ad
        val nativeAdView = layoutInflater.inflate(layoutId, null) as NativeAdView

        val iconView = nativeAdView.findViewById<ImageView>(R.id.ad_app_icon)
        val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
        val ctaView = nativeAdView.findViewById<Button>(R.id.ad_call_to_action)

        nativeAd.icon?.let {
            iconView.setImageDrawable(it.drawable)
            iconView.visibility = View.VISIBLE
            nativeAdView.iconView = iconView
            Log.v(TAG, "[NativeAdFactory] STATE: ICON_BOUND")
        } ?: run {
            iconView.visibility = View.GONE
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
        Log.i(TAG, "[NativeAdFactory] STATE: NATIVE_AD_RENDERED | headline: ${nativeAd.headline}")
        return nativeAdView
    }
}

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null
    private val nativeAdFactoryId = "castflow_native_ad"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "castflow/network").setMethodCallHandler { call, result ->
            when (call.method) {
                // Android filters incoming multicast unless a lock is held, which
                // breaks SSDP/mDNS TV discovery.
                "acquireMulticastLock" -> {
                    if (multicastLock == null) {
                        val wifi = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                        multicastLock = wifi.createMulticastLock("castflow-discovery").apply {
                            setReferenceCounted(false)
                            acquire()
                        }
                    }
                    result.success(true)
                }
                "releaseMulticastLock" -> {
                    multicastLock?.let { if (it.isHeld) it.release() }
                    multicastLock = null
                    result.success(true)
                }
                // System cast / Smart View screen for screen mirroring.
                "openCastSettings" -> {
                    val opened = listOf(
                        Intent("android.settings.CAST_SETTINGS"),
                        Intent("com.samsung.android.smartmirroring.CAPTURE"),
                        Intent(Settings.ACTION_WIRELESS_SETTINGS),
                    ).any { intent ->
                        try {
                            startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); true
                        } catch (_: Exception) {
                            false
                        }
                    }
                    result.success(opened)
                }
                // Wi-Fi (via ConnectivityManager) and own-hotspot state (via the
                // AP network interface; WifiManager is unreliable for this).
                "networkStatus" -> {
                    val ap = hotspotInterface()
                    result.success(
                        mapOf(
                            "wifi" to isWifiConnected(),
                            "hotspot" to (ap != null),
                            "hotspotInterface" to ap?.first,
                            "hotspotIp" to ap?.second,
                            "vpn" to isVpnActive(),
                        )
                    )
                }
                // Smart View / Cast screen mirroring adds a presentation display
                // while it runs; its name is the TV.
                "mirroringStatus" -> {
                    val dm = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
                    val display = dm.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)
                        .firstOrNull { it.displayId != Display.DEFAULT_DISPLAY }
                    result.success(mapOf("active" to (display != null), "name" to display?.name))
                }
                "openWifiSettings" -> result.success(launch(Intent(Settings.ACTION_WIFI_SETTINGS)))
                "openLocationSettings" -> result.success(launch(Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)))
                // Hotspot can't be enabled programmatically on modern Android, so
                // open the system tethering screen instead.
                "openHotspotSettings" -> {
                    val tether = Intent(Intent.ACTION_MAIN).setComponent(
                        ComponentName("com.android.settings", "com.android.settings.TetherSettings")
                    )
                    result.success(launch(tether) || launch(Intent(Settings.ACTION_WIRELESS_SETTINGS)))
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, nativeAdFactoryId)
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun launch(intent: Intent): Boolean = try {
        startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)); true
    } catch (_: Exception) {
        false
    }

    /** True when any connected network uses the Wi-Fi transport. */
    private fun isWifiConnected(): Boolean {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        @Suppress("DEPRECATION")
        return cm.allNetworks.any { n ->
            val caps = cm.getNetworkCapabilities(n) ?: return@any false
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) &&
                caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_SUSPENDED)
        }
    }

    /** A VPN hides LAN devices (TVs) from the phone. */
    private fun isVpnActive(): Boolean {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        @Suppress("DEPRECATION")
        return cm.allNetworks.any { cm.getNetworkCapabilities(it)?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true }
    }

    /** The active access-point interface (name, IPv4) when our hotspot is on. */
    private fun hotspotInterface(): Pair<String, String>? {
        val apNames = listOf("ap0", "swlan0", "wlan1", "softap0", "ap_br_wlan0")
        return try {
            NetworkInterface.getNetworkInterfaces()?.toList().orEmpty()
                .filter { it.isUp && !it.isLoopback && (it.name in apNames || it.name.startsWith("ap")) }
                .firstNotNullOfOrNull { iface ->
                    iface.inetAddresses.toList()
                        .firstOrNull { it is Inet4Address && !it.isLoopbackAddress }
                        ?.let { iface.name to it.hostAddress!! }
                }
        } catch (_: Exception) {
            null
        }
    }

    override fun onDestroy() {
        multicastLock?.let { if (it.isHeld) it.release() }
        super.onDestroy()
    }
}
