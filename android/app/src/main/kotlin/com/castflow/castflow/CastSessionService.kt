package com.castflow.castflow

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log

/**
 * Foreground service held while media is being cast to a TV.
 *
 * The TV pulls the file from the phone's own HTTP server (Dart, in this process). With
 * the screen off Android would otherwise freeze or kill the process and the TV's stream
 * would stop. Type "mediaPlayback" (Android 10+ types, required on Android 14+), started
 * only while the app is in the foreground (Android 12+ background-start limits). The
 * notification needs POST_NOTIFICATIONS on Android 13+; without it the service still
 * runs, the notification is just hidden.
 */
class CastSessionService : Service() {
    companion object {
        private const val TAG = "CastSession"
        private const val CHANNEL_ID = "cast_session"
        private const val NOTIFICATION_ID = 4107
        private const val EXTRA_TITLE = "title"

        fun start(context: Context, title: String?): Boolean = try {
            val intent = Intent(context, CastSessionService::class.java).putExtra(EXTRA_TITLE, title)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
            true
        } catch (e: Exception) {
            // e.g. ForegroundServiceStartNotAllowedException when called from the background.
            Log.w(TAG, "start: $e")
            false
        }

        fun stop(context: Context) {
            try {
                context.stopService(Intent(context, CastSessionService::class.java))
            } catch (_: Exception) {
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = buildNotification(intent?.getStringExtra(EXTRA_TITLE))
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            Log.w(TAG, "startForeground: $e")
            stopSelf()
        }
        // Not restarted by the system: a restarted service would have no cast to keep alive.
        return START_NOT_STICKY
    }

    /** Android 15: mediaPlayback services get a timeout callback when time runs out. */
    override fun onTimeout(startId: Int, fgsType: Int) {
        stopSelf()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // App swiped away: the cast session (and its server) is gone too.
        stopSelf()
        super.onTaskRemoved(rootIntent)
    }

    private fun buildNotification(title: String?): Notification {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && manager.getNotificationChannel(CHANNEL_ID) == null) {
            manager.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, getString(R.string.cast_session_channel), NotificationManager.IMPORTANCE_LOW).apply {
                    setShowBadge(false)
                }
            )
        }
        val open = packageManager.getLaunchIntentForPackage(packageName)?.let {
            PendingIntent.getActivity(this, 0, it, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        }
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentTitle(getString(R.string.cast_session_title))
            .setContentText(title ?: getString(R.string.cast_session_text))
            .setContentIntent(open)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
    }
}
