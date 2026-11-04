package com.castflow.castflow

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.view.Display
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import java.net.Inet4Address
import java.net.NetworkInterface
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
