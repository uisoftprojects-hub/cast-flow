package com.castflow.castflow

import android.app.Activity
import android.app.Application
import android.os.Build
import android.os.Bundle
import android.view.KeyEvent
import android.view.Window
import android.window.OnBackInvokedCallback
import android.window.OnBackInvokedDispatcher
import java.util.Collections
import java.util.WeakHashMap

/**
 * Disables the Android Back button / back gesture while a full-screen Google ad
 * (interstitial or App Open) is on screen. Those ads run in Google's own
 * `AdActivity`, outside Flutter, so Flutter's PopScope cannot reach them; the
 * only way in is the activity lifecycle.
 *
 * Two layers, so it holds on every Android version:
 *  1. Window.Callback wrapper: swallows KEYCODE_BACK (3-button nav, legacy back, API < 33).
 *  2. OnBackInvokedCallback (PRIORITY_OVERLAY): consumes the predictive-back gesture (API 33+).
 *
 * The ad can still be closed with its own close (X) button.
 */
object AdBackBlocker : Application.ActivityLifecycleCallbacks {
    private const val AD_ACTIVITY_PREFIX = "com.google.android.gms.ads."

    private val backCallbacks = Collections.synchronizedMap(WeakHashMap<Activity, Any>())

    /** Ad activities that opened while Flutter reported a full-screen ad (interstitial / App Open). */
    private val marked = Collections.synchronizedSet(Collections.newSetFromMap(WeakHashMap<Activity, Boolean>()))

    /**
     * Set from Flutter (AdDisplayCoordinator) for exactly the time a full-screen ad is presented.
     * Other Google activities (e.g. a native ad's landing page) are NOT locked, so the user can
     * always go back from those.
     */
    @Volatile
    var locked = false

    fun install(app: Application) {
        app.unregisterActivityLifecycleCallbacks(this)
        app.registerActivityLifecycleCallbacks(this)
    }

    private fun isAdActivity(activity: Activity) =
        activity.javaClass.name.startsWith(AD_ACTIVITY_PREFIX)

    private fun block(activity: Activity) {
        if (!isAdActivity(activity)) return
        if (!marked.contains(activity)) {
            if (!locked) return
            marked.add(activity)
        }
        val window = activity.window ?: return

        val current = window.callback
        if (current != null && current !is BackBlockingCallback) {
            window.callback = BackBlockingCallback(current)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            !backCallbacks.containsKey(activity)
        ) {
            val callback = OnBackInvokedCallback { /* swallow: back does nothing on an ad */ }
            activity.onBackInvokedDispatcher.registerOnBackInvokedCallback(
                OnBackInvokedDispatcher.PRIORITY_OVERLAY,
                callback
            )
            backCallbacks[activity] = callback
        }
    }

    // The ad activity may replace its window callback after onCreate, so re-check at every stage.
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) = block(activity)
    override fun onActivityStarted(activity: Activity) = block(activity)
    override fun onActivityResumed(activity: Activity) = block(activity)
    override fun onActivityPaused(activity: Activity) {}
    override fun onActivityStopped(activity: Activity) {}
    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

    override fun onActivityDestroyed(activity: Activity) {
        marked.remove(activity)
        val callback = backCallbacks.remove(activity)
        if (callback != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.onBackInvokedDispatcher.unregisterOnBackInvokedCallback(callback as OnBackInvokedCallback)
        }
    }

    private class BackBlockingCallback(private val base: Window.Callback) : Window.Callback by base {
        override fun dispatchKeyEvent(event: KeyEvent): Boolean {
            if (event.keyCode == KeyEvent.KEYCODE_BACK) return true
            return base.dispatchKeyEvent(event)
        }
    }
}
