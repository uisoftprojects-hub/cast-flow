package com.castflow.castflow

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.LinkProperties
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import io.flutter.plugin.common.EventChannel
import java.net.Inet4Address
import java.net.NetworkInterface

/** One local network the phone is on: interface name, IPv4 address and prefix length. */
data class LanAddress(val iface: String, val ip: String, val prefix: Int)

/**
 * Wi-Fi / own-hotspot state for TV discovery and casting.
 *
 * - Wi-Fi comes from ConnectivityManager (TRANSPORT_WIFI networks and their LinkProperties).
 * - The hotspot is not a "Network" apps can see, so it is detected two ways:
 *   WifiManager's hidden isWifiApEnabled / getWifiApState (reflection, blocked on some
 *   versions), and the access-point network interface (ap0, swlan0, wlan1, softap*, ...)
 *   holding an IPv4 address. OEMs name that interface differently, hence the fallbacks.
 * - Changes are pushed to Flutter as they happen (NetworkCallback + the AP state broadcast),
 *   so the UI can leave the "no network" screen the moment Wi-Fi or the hotspot comes up.
 */
class NetworkMonitor(
    private val context: Context,
    /** Starts a settings screen from the Activity, so it opens over the app's own task. */
    private val launcher: (Intent) -> Boolean,
) : EventChannel.StreamHandler {
    companion object {
        private const val TAG = "CastNetwork"
        private const val ACTION_AP_STATE = "android.net.wifi.WIFI_AP_STATE_CHANGED"

        // WifiManager.WIFI_AP_STATE_ENABLED (13), and the pre-Android 4 value (3).
        private val AP_ENABLED_STATES = setOf(13, 3)

        /** Interface names OEMs use for the Wi-Fi access point. */
        private val AP_NAME = Regex("^(ap\\d*|ap_br_.*|swlan\\d+|softap\\d*|wlan[1-9]\\d*|wifi_ap\\d*|wl\\d+\\.\\d+)$")

        /** Interfaces that are never the hotspot (cellular, VPN, tunnels, Wi-Fi Direct...). */
        private val NOT_AP = listOf(
            "lo", "rmnet", "r_rmnet", "ccmni", "ccemni", "pdp", "tun", "ppp", "ipsec", "dummy",
            "ifb", "ip6tnl", "ip_vti", "sit", "v4-", "clat", "p2p", "bt-pan", "rndis", "usb", "ncm",
            "eth", "docker", "veth", "seth", "wigig", "nan", "aware", "epdg", "radio", "gre", "erspan",
        )
    }

    private val connectivity = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    private val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    private val main = Handler(Looper.getMainLooper())

    private var sink: EventChannel.EventSink? = null
    private var callback: ConnectivityManager.NetworkCallback? = null
    private var apReceiver: BroadcastReceiver? = null
    private var lastSent: Map<String, Any?>? = null

    // ----------------------------------------------------------- multicast

    private var multicastLock: WifiManager.MulticastLock? = null
    private var multicastHolders = 0

    /**
     * Android drops incoming multicast (SSDP / mDNS replies) unless a lock is held.
     * Counted: discovery and TV identification can overlap, and one finishing must not
     * release the lock under the other.
     */
    @Synchronized
    fun acquireMulticast() {
        multicastHolders++
        val lock = multicastLock ?: wifiManager.createMulticastLock("castflow-discovery").apply {
            setReferenceCounted(false)
        }.also { multicastLock = it }
        if (!lock.isHeld) {
            try {
                lock.acquire()
            } catch (e: Exception) {
                Log.w(TAG, "multicast lock: $e")
            }
        }
    }

    @Synchronized
    fun releaseMulticast() {
        if (multicastHolders > 0) multicastHolders--
        if (multicastHolders == 0) multicastLock?.let { if (it.isHeld) it.release() }
    }

    @Synchronized
    fun releaseAllMulticast() {
        multicastHolders = 0
        multicastLock?.let { if (it.isHeld) it.release() }
        multicastLock = null
    }

    // -------------------------------------------------------------- status

    fun status(): Map<String, Any?> {
        val wifi = wifiAddress()
        val wifiUp = wifi != null || isWifiConnected()
        val ap = hotspotAddress(wifi?.iface)
        return mapOf(
            "wifi" to wifiUp,
            "wifiInterface" to wifi?.iface,
            "wifiIp" to wifi?.ip,
            "wifiPrefix" to wifi?.prefix,
            "hotspot" to (ap != null),
            "hotspotInterface" to ap?.iface,
            "hotspotIp" to ap?.ip,
            "hotspotPrefix" to ap?.prefix,
            "vpn" to isVpnActive(),
            "internet" to hasInternet(),
        )
    }

    /** The default network reaches the internet (Wi-Fi, mobile data or hotspot upstream), validated by Android. */
    private fun hasInternet(): Boolean {
        val net = connectivity.activeNetwork ?: return false
        val caps = connectivity.getNetworkCapabilities(net) ?: return false
        return caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
            caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
    }

    /** True when any connected network uses the Wi-Fi transport. */
    private fun isWifiConnected(): Boolean {
        @Suppress("DEPRECATION")
        return connectivity.allNetworks.any { n ->
            val caps = connectivity.getNetworkCapabilities(n) ?: return@any false
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) &&
                caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_SUSPENDED)
        }
    }

    /** The phone's own address on the Wi-Fi it joined (the station side, not the hotspot). */
    private fun wifiAddress(): LanAddress? {
        @Suppress("DEPRECATION")
        for (n in connectivity.allNetworks) {
            val caps = connectivity.getNetworkCapabilities(n) ?: continue
            if (!caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) continue
            if (caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) continue
            val lp: LinkProperties = connectivity.getLinkProperties(n) ?: continue
            val iface = lp.interfaceName ?: continue
            val la = lp.linkAddresses.firstOrNull { it.address is Inet4Address && !it.address.isLoopbackAddress }
                ?: continue
            return LanAddress(iface, la.address.hostAddress ?: continue, la.prefixLength)
        }
        return null
    }

    /** A VPN hides LAN devices (TVs) from the phone. */
    private fun isVpnActive(): Boolean {
        @Suppress("DEPRECATION")
        return connectivity.allNetworks.any {
            connectivity.getNetworkCapabilities(it)?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true
        }
    }

    /**
     * WifiManager's own answer, or null when the hidden API is unavailable (blocked by
     * the non-SDK interface restrictions on some versions/OEMs).
     */
    private fun apEnabledByWifiManager(): Boolean? {
        try {
            val m = wifiManager.javaClass.getDeclaredMethod("isWifiApEnabled")
            m.isAccessible = true
            return m.invoke(wifiManager) as Boolean
        } catch (_: Throwable) {
        }
        try {
            val m = wifiManager.javaClass.getDeclaredMethod("getWifiApState")
            m.isAccessible = true
            return (m.invoke(wifiManager) as Int) in AP_ENABLED_STATES
        } catch (_: Throwable) {
        }
        return null
    }

    private fun ipv4Of(iface: NetworkInterface): LanAddress? {
        for (ia in iface.interfaceAddresses) {
            val a = ia.address
            if (a is Inet4Address && !a.isLoopbackAddress && !a.isLinkLocalAddress) {
                return LanAddress(iface.name, a.hostAddress ?: continue, ia.networkPrefixLength.toInt())
            }
        }
        return null
    }

    /** The access-point interface and our address on it, when the phone's hotspot is on. */
    fun hotspotAddress(stationIface: String? = wifiAddress()?.iface): LanAddress? {
        val ifaces = try {
            NetworkInterface.getNetworkInterfaces()?.toList().orEmpty()
        } catch (_: Exception) {
            emptyList()
        }.filter {
            try {
                it.isUp && !it.isLoopback && it.name != stationIface
            } catch (_: Exception) {
                false
            }
        }
        val named = ifaces.filter { AP_NAME.matches(it.name) }.firstNotNullOfOrNull(::ipv4Of)
        val byWifiManager = apEnabledByWifiManager()
        return when (byWifiManager) {
            // WifiManager says the hotspot is on: take the AP interface, or (OEMs with
            // unusual names, e.g. "wlan0" as the AP while Wi-Fi is off) any other up,
            // non-cellular, non-VPN interface with a private IPv4 address.
            true -> named ?: ifaces
                .filter { i -> NOT_AP.none { i.name.startsWith(it) } }
                .firstNotNullOfOrNull { ipv4Of(it)?.takeIf { a -> isPrivate(a.ip) } }
            // WifiManager says off: only trust an interface that is unmistakably an AP.
            false -> named?.takeIf { it.iface.startsWith("ap") || it.iface.startsWith("swlan") || it.iface.startsWith("softap") }
            // Unknown: the interface check alone.
            null -> named
        }
    }

    private fun isPrivate(ip: String): Boolean {
        val p = ip.split('.').mapNotNull { it.toIntOrNull() }
        if (p.size != 4) return false
        return p[0] == 10 || (p[0] == 172 && p[1] in 16..31) || (p[0] == 192 && p[1] == 168)
    }

    // -------------------------------------------------------------- events

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        lastSent = null
        register()
        emit()
    }

    override fun onCancel(arguments: Any?) {
        unregister()
        sink = null
    }

    private fun emit() {
        main.post {
            val s = sink ?: return@post
            val now = try {
                status()
            } catch (e: Exception) {
                Log.w(TAG, "status: $e")
                return@post
            }
            if (now != lastSent) {
                lastSent = now
                s.success(now)
            }
        }
    }

    /** The AP interface gets its address a moment after the state change: check a few times. */
    private fun emitSoon() {
        emit()
        for (delay in longArrayOf(400, 1200, 2500, 5000)) main.postDelayed({ emit() }, delay)
    }

    private fun register() {
        if (callback == null) {
            val cb = object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) = emitSoon()
                override fun onLost(network: Network) = emitSoon()
                override fun onCapabilitiesChanged(network: Network, caps: NetworkCapabilities) = emit()
                override fun onLinkPropertiesChanged(network: Network, lp: LinkProperties) = emit()
            }
            try {
                // Wi-Fi and VPN changes (a VPN coming up hides TVs too).
                val request = NetworkRequest.Builder()
                    .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                    .addTransportType(NetworkCapabilities.TRANSPORT_VPN)
                    .removeCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN)
                    .build()
                connectivity.registerNetworkCallback(request, cb)
                callback = cb
            } catch (e: Exception) {
                Log.w(TAG, "network callback: $e")
            }
        }
        if (apReceiver == null) {
            val r = object : BroadcastReceiver() {
                override fun onReceive(c: Context?, intent: Intent?) = emitSoon()
            }
            val filter = IntentFilter(ACTION_AP_STATE).apply {
                addAction(WifiManager.WIFI_STATE_CHANGED_ACTION)
            }
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    context.registerReceiver(r, filter, Context.RECEIVER_EXPORTED)
                } else {
                    @Suppress("UnspecifiedRegisterReceiverFlag")
                    context.registerReceiver(r, filter)
                }
                apReceiver = r
            } catch (e: Exception) {
                Log.w(TAG, "AP receiver: $e")
            }
        }
    }

    fun unregister() {
        main.removeCallbacksAndMessages(null)
        callback?.let {
            try {
                connectivity.unregisterNetworkCallback(it)
            } catch (_: Exception) {
            }
        }
        callback = null
        apReceiver?.let {
            try {
                context.unregisterReceiver(it)
            } catch (_: Exception) {
            }
        }
        apReceiver = null
    }

    // ------------------------------------------------------------ settings

    private fun launch(intent: Intent): Boolean = launcher(intent)

    /** Android 10+: the Wi-Fi panel over the app; older: the Wi-Fi settings screen. */
    fun openWifiPanel(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && launch(Intent(Settings.Panel.ACTION_WIFI))) return true
        return launch(Intent(Settings.ACTION_WIFI_SETTINGS)) || launch(Intent(Settings.ACTION_WIRELESS_SETTINGS))
    }

    /**
     * The system hotspot / tethering screen. The hotspot can't be turned on by apps on
     * modern Android, so this is as close as it gets. Tried in order: the (hidden) tether
     * action, AOSP's activity aliases, then the wireless settings as a last resort.
     */
    fun openHotspotSettings(): Boolean {
        val candidates = listOf(
            Intent("android.settings.TETHER_SETTINGS"),
            Intent("android.settings.WIFI_TETHER_SETTINGS"),
            Intent(Intent.ACTION_MAIN).setComponent(
                ComponentName("com.android.settings", "com.android.settings.Settings\$TetherSettingsActivity")
            ),
            Intent(Intent.ACTION_MAIN).setComponent(
                ComponentName("com.android.settings", "com.android.settings.TetherSettings")
            ),
            Intent(Intent.ACTION_MAIN).setComponent(
                ComponentName("com.android.settings", "com.android.settings.Settings\$WifiTetherSettingsActivity")
            ),
            Intent(Settings.ACTION_WIRELESS_SETTINGS),
        )
        return candidates.any(::launch)
    }
}
