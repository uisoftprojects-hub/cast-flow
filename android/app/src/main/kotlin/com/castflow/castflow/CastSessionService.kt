package com.castflow.castflow

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.drawable.Icon
import android.media.MediaMetadata
import android.media.session.MediaSession
import android.media.session.PlaybackState
import android.os.Build
import android.os.IBinder
import android.util.Log

/** Carries the notification's buttons and seek bar to Flutter (set by MainActivity). */
object CastSessionBridge {
    /** name: play, pause, next, previous, stop, seek (positionMs). Called on the main thread. */
    @Volatile
    var onCommand: ((name: String, positionMs: Long) -> Unit)? = null
}

/** What the notification shows; sent from Flutter whenever playback changes. */
data class CastSessionInfo(
    val title: String,
    val subtitle: String?,
    val playing: Boolean,
    val positionMs: Long,
    val durationMs: Long,
    val hasPrevious: Boolean,
    val hasNext: Boolean,
    val preparing: Boolean,
)

/**
 * Foreground service held while media is being cast to a TV, with a media
 * notification: title, previous / play-pause / next / stop buttons and a seek bar.
 *
 * The TV pulls the file from the phone's own HTTP server (Dart, in this process). With
 * the screen off Android would otherwise freeze or kill the process and the TV's stream
 * would stop. Type "mediaPlayback" (Android 10+ types, required on Android 14+), started
 * only while the app is in the foreground (Android 12+ background-start limits).
 *
 * The buttons and the seek bar (Android 13+ notification, lock screen, Bluetooth and
 * headset keys) all go through a MediaSession whose state mirrors the cast. The system
 * extrapolates the position from (position, speed, update time), so Flutter only needs
 * to send an update when something changes, not every second. The notification needs
 * POST_NOTIFICATIONS on Android 13+; without it the service and the session still work.
 */
class CastSessionService : Service() {
    companion object {
        private const val TAG = "CastSession"
        private const val CHANNEL_ID = "cast_session"
        private const val NOTIFICATION_ID = 4107
        private const val EXTRA_TITLE = "title"
        private const val ACTION_PREFIX = "com.castflow.castflow.cast."

        @Volatile
        private var instance: CastSessionService? = null

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

        /** Updates the notification and the media session; ignored while the service isn't running. */
        fun update(info: CastSessionInfo) {
            instance?.apply(info)
        }
    }

    private var session: MediaSession? = null
    private var info: CastSessionInfo? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
        session = MediaSession(this, "CastFlow").apply {
            setCallback(object : MediaSession.Callback() {
                override fun onPlay() = send("play")
                override fun onPause() = send("pause")
                override fun onSkipToNext() = send("next")
                override fun onSkipToPrevious() = send("previous")
                override fun onStop() = send("stop")
                override fun onSeekTo(pos: Long) = send("seek", pos)
            })
            isActive = true
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action != null && action.startsWith(ACTION_PREFIX)) {
            // A notification button.
            send(action.removePrefix(ACTION_PREFIX))
            return START_NOT_STICKY
        }
        val notification = buildNotification(info ?: CastSessionInfo(
            title = intent?.getStringExtra(EXTRA_TITLE) ?: getString(R.string.cast_session_text),
            subtitle = null, playing = true, positionMs = 0, durationMs = 0,
            hasPrevious = false, hasNext = false, preparing = false,
        ))
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

    private fun send(name: String, positionMs: Long = 0) {
        CastSessionBridge.onCommand?.invoke(name, positionMs)
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

    override fun onDestroy() {
        instance = null
        session?.apply {
            isActive = false
            release()
        }
        session = null
        super.onDestroy()
    }

    // ---------------------------------------------------------------- state

    private fun apply(next: CastSessionInfo) {
        info = next
        val s = session ?: return
        s.setMetadata(
            MediaMetadata.Builder()
                .putString(MediaMetadata.METADATA_KEY_TITLE, next.title)
                .putString(MediaMetadata.METADATA_KEY_ARTIST, next.subtitle ?: getString(R.string.cast_session_text))
                .putLong(MediaMetadata.METADATA_KEY_DURATION, if (next.durationMs > 0) next.durationMs else -1)
                .build()
        )
        var actions = PlaybackState.ACTION_PLAY or PlaybackState.ACTION_PAUSE or PlaybackState.ACTION_PLAY_PAUSE or
            PlaybackState.ACTION_STOP
        if (next.hasNext) actions = actions or PlaybackState.ACTION_SKIP_TO_NEXT
        if (next.hasPrevious) actions = actions or PlaybackState.ACTION_SKIP_TO_PREVIOUS
        // The seek bar only when the length is known (not for photos / live streams).
        if (next.durationMs > 0) actions = actions or PlaybackState.ACTION_SEEK_TO
        val state = when {
            next.preparing -> PlaybackState.STATE_BUFFERING
            next.playing -> PlaybackState.STATE_PLAYING
            else -> PlaybackState.STATE_PAUSED
        }
        s.setPlaybackState(
            PlaybackState.Builder()
                .setActions(actions)
                .setState(state, next.positionMs, if (next.playing && !next.preparing) 1f else 0f)
                .build()
        )
        try {
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .notify(NOTIFICATION_ID, buildNotification(next))
        } catch (e: Exception) {
            Log.w(TAG, "notify: $e")
        }
    }

    private fun actionIntent(name: String, code: Int): PendingIntent = PendingIntent.getService(
        this,
        code,
        Intent(this, CastSessionService::class.java).setAction(ACTION_PREFIX + name),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )

    private fun action(icon: Int, label: String, name: String, code: Int): Notification.Action =
        Notification.Action.Builder(Icon.createWithResource(this, icon), label, actionIntent(name, code)).build()

    private fun buildNotification(i: CastSessionInfo): Notification {
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

        // previous | play-pause | next | stop; unavailable ones are left out.
        val compact = mutableListOf<Int>()
        var index = 0
        if (i.hasPrevious) {
            builder.addAction(action(android.R.drawable.ic_media_previous, "Previous", "previous", 1))
            compact.add(index++)
        }
        if (i.playing) {
            builder.addAction(action(android.R.drawable.ic_media_pause, "Pause", "pause", 2))
        } else {
            builder.addAction(action(android.R.drawable.ic_media_play, "Play", "play", 3))
        }
        compact.add(index++)
        if (i.hasNext) {
            builder.addAction(action(android.R.drawable.ic_media_next, "Next", "next", 4))
            compact.add(index++)
        }
        builder.addAction(action(android.R.drawable.ic_menu_close_clear_cancel, "Stop", "stop", 5))

        val style = Notification.MediaStyle().setShowActionsInCompactView(*compact.take(3).toIntArray())
        session?.let { style.setMediaSession(it.sessionToken) }

        return builder
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentTitle(i.title)
            .setContentText(
                if (i.preparing) getString(R.string.cast_session_converting)
                else i.subtitle ?: getString(R.string.cast_session_title)
            )
            .setContentIntent(open)
            .setStyle(style)
            .setOngoing(i.playing)
            .setOnlyAlertOnce(true)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
    }
}
