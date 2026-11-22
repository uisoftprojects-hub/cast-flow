package com.castflow.castflow

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageDecoder
import android.graphics.Matrix
import android.media.ExifInterface
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.util.Log
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.effect.Presentation
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.Effects
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.ProgressHolder
import androidx.media3.transformer.Transformer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.security.MessageDigest
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

/**
 * Converts media the TV can't play, on the fly:
 * - video -> MP4 (H.264 + AAC) with androidx.media3 Transformer, at most 1080p;
 * - image -> JPEG (from HEIC/HEIF, WebP, PNG, ...), EXIF orientation applied.
 *
 * Everything runs off the main thread (a single image worker, and one looper thread that
 * owns the Transformers). Results are cached by source path + size + mtime under
 * cacheDir/cast_convert, written to a ".part" file first so a half-written file is never
 * served, and deleted with [clearCache] when the cast session ends.
 */
class MediaConvert(private val context: Context, private val channel: MethodChannel) :
    MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "CastConvert"
        private const val MAX_VIDEO_HEIGHT = 1080
        private const val MAX_IMAGE_SIDE = 3840
    }

    private val main = Handler(Looper.getMainLooper())
    private val imageWorker = Executors.newSingleThreadExecutor()
    private val transformThread = HandlerThread("cast-transformer").apply { start() }
    private val transformHandler = Handler(transformThread.looper)
    /** A running export: cancelling it must still answer Flutter, the listener won't. */
    private class Job(val transformer: Transformer, val result: MethodChannel.Result, val part: File) {
        var done = false
    }

    private val running = ConcurrentHashMap<String, Job>()

    private val dir: File
        get() = File(context.cacheDir, "cast_convert").apply { mkdirs() }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "probe" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                imageWorker.execute {
                    val info = probe(path)
                    main.post { result.success(info) }
                }
            }
            "convertImage" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                imageWorker.execute {
                    try {
                        val out = convertImage(path)
                        main.post { result.success(out) }
                    } catch (e: Throwable) {
                        Log.w(TAG, "image: $e")
                        main.post { result.error("convert", e.message ?: e.toString(), null) }
                    }
                }
            }
            "convertVideo" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                val id = call.argument<String>("id") ?: path
                transformHandler.post { convertVideo(path, id, result, removeAudio = false) }
            }
            "cancel" -> {
                val id = call.argument<String>("id")
                transformHandler.post {
                    if (id == null) cancelAll() else running.remove(id)?.let(::cancel)
                }
                result.success(true)
            }
            "clearCache" -> {
                transformHandler.post {
                    cancelAll()
                    imageWorker.execute { dir.deleteRecursively() }
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    /** Called when the engine goes away: stop work and free the threads. */
    fun dispose() {
        transformHandler.post {
            cancelAll()
            transformThread.quitSafely()
        }
        imageWorker.shutdown()
    }

    private fun cancel(job: Job) {
        if (job.done) return
        job.done = true
        job.transformer.cancel()
        job.part.delete()
        main.post { job.result.error("cancelled", "Conversion cancelled.", null) }
    }

    private fun cancelAll() {
        val jobs = running.values.toList()
        running.clear()
        jobs.forEach(::cancel)
    }

    // ----------------------------------------------------------------- probe

    /** Container MIME type and the codec of the first video and audio track. */
    private fun probe(path: String): Map<String, Any?> {
        val out = mutableMapOf<String, Any?>()
        try {
            MediaMetadataRetriever().apply {
                try {
                    setDataSource(path)
                    out["mime"] = extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE)
                    out["height"] = extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toIntOrNull()
                    out["width"] = extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toIntOrNull()
                } finally {
                    release()
                }
            }
        } catch (_: Throwable) {
        }
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(path)
            for (i in 0 until extractor.trackCount) {
                val mime = extractor.getTrackFormat(i).getString(MediaFormat.KEY_MIME) ?: continue
                if (mime.startsWith("video/") && out["video"] == null) out["video"] = mime
                if (mime.startsWith("audio/") && out["audio"] == null) out["audio"] = mime
            }
        } catch (_: Throwable) {
        } finally {
            extractor.release()
        }
        return out
    }

    // ----------------------------------------------------------------- cache

    private fun cacheFile(path: String, ext: String): File {
        val src = File(path)
        val key = "${src.absolutePath}|${src.length()}|${src.lastModified()}|$ext"
        val hash = MessageDigest.getInstance("SHA-1").digest(key.toByteArray())
            .joinToString("") { "%02x".format(it) }
        return File(dir, "$hash.$ext")
    }

    // ----------------------------------------------------------------- image

    private fun convertImage(path: String): String {
        val out = cacheFile(path, "jpg")
        if (out.length() > 0) return out.absolutePath
        val bitmap = decode(path) ?: throw IllegalStateException("This photo can't be read.")
        val part = File(out.path + ".part")
        try {
            FileOutputStream(part).use { bitmap.compress(Bitmap.CompressFormat.JPEG, 90, it) }
        } finally {
            bitmap.recycle()
        }
        if (!part.renameTo(out)) throw IllegalStateException("Couldn't save the converted photo.")
        return out.absolutePath
    }

    /** Decodes any supported image, scaled to at most [MAX_IMAGE_SIDE], upright. */
    private fun decode(path: String): Bitmap? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return try {
                // ImageDecoder handles HEIF/AVIF/WebP and applies EXIF orientation itself.
                ImageDecoder.decodeBitmap(ImageDecoder.createSource(File(path))) { decoder, info, _ ->
                    decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
                    val w = info.size.width
                    val h = info.size.height
                    val longest = maxOf(w, h)
                    if (longest > MAX_IMAGE_SIDE) {
                        val scale = MAX_IMAGE_SIDE.toFloat() / longest
                        decoder.setTargetSize((w * scale).toInt().coerceAtLeast(1), (h * scale).toInt().coerceAtLeast(1))
                    }
                }
            } catch (e: Throwable) {
                Log.w(TAG, "ImageDecoder: $e")
                decodeLegacy(path)
            }
        }
        return decodeLegacy(path)
    }

    private fun decodeLegacy(path: String): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        var sample = 1
        while (maxOf(bounds.outWidth, bounds.outHeight) / sample > MAX_IMAGE_SIDE) sample *= 2
        val bmp = BitmapFactory.decodeFile(path, BitmapFactory.Options().apply { inSampleSize = sample })
            ?: return null
        val degrees = try {
            when (ExifInterface(path).getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)) {
                ExifInterface.ORIENTATION_ROTATE_90 -> 90f
                ExifInterface.ORIENTATION_ROTATE_180 -> 180f
                ExifInterface.ORIENTATION_ROTATE_270 -> 270f
                else -> 0f
            }
        } catch (_: Exception) {
            0f
        }
        if (degrees == 0f) return bmp
        val rotated = Bitmap.createBitmap(bmp, 0, 0, bmp.width, bmp.height, Matrix().apply { postRotate(degrees) }, true)
        if (rotated != bmp) bmp.recycle()
        return rotated
    }

    // ----------------------------------------------------------------- video

    /** Runs on [transformThread]: Transformer must be used from its looper's thread. */
    private fun convertVideo(path: String, id: String, result: MethodChannel.Result, removeAudio: Boolean) {
        val out = cacheFile(path, "mp4")
        if (out.length() > 0) {
            main.post { result.success(out.absolutePath) }
            return
        }
        val part = File(out.path + ".part")
        part.delete()

        val height = try {
            MediaMetadataRetriever().run {
                try {
                    setDataSource(path)
                    val w = extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toIntOrNull() ?: 0
                    val h = extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toIntOrNull() ?: 0
                    minOf(w, h) // the short side, whatever the rotation
                } finally {
                    release()
                }
            }
        } catch (_: Throwable) {
            0
        }

        val item = EditedMediaItem.Builder(MediaItem.fromUri(Uri.fromFile(File(path))))
            .setRemoveAudio(removeAudio)
            .apply {
                if (height > MAX_VIDEO_HEIGHT) {
                    setEffects(Effects(listOf(), listOf(Presentation.createForShortSide(MAX_VIDEO_HEIGHT))))
                }
            }
            .build()

        val progress = ProgressHolder()
        lateinit var job: Job
        val poll = object : Runnable {
            override fun run() {
                if (job.done) return
                if (job.transformer.getProgress(progress) == Transformer.PROGRESS_STATE_AVAILABLE) {
                    val p = progress.progress / 100.0
                    main.post { channel.invokeMethod("progress", mapOf("id" to id, "progress" to p)) }
                }
                transformHandler.postDelayed(this, 500)
            }
        }

        val transformer = Transformer.Builder(context)
            .setLooper(transformThread.looper)
            .setVideoMimeType(MimeTypes.VIDEO_H264)
            .setAudioMimeType(MimeTypes.AUDIO_AAC)
            .addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, exportResult: ExportResult) {
                    if (job.done) return
                    job.done = true
                    running.remove(id)
                    if (part.renameTo(out)) {
                        main.post { result.success(out.absolutePath) }
                    } else {
                        main.post { result.error("convert", "Couldn't save the converted video.", null) }
                    }
                }

                override fun onError(composition: Composition, exportResult: ExportResult, exportException: ExportException) {
                    if (job.done) return
                    job.done = true
                    running.remove(id)
                    part.delete()
                    Log.w(TAG, "video: ${exportException.errorCodeName}: ${exportException.message}")
                    // An audio track this phone can't decode (AC-3, DTS...) shouldn't stop the
                    // picture: try once more without sound.
                    val audioFailed = exportException.errorCode == ExportException.ERROR_CODE_DECODING_FORMAT_UNSUPPORTED ||
                        exportException.errorCode == ExportException.ERROR_CODE_DECODER_INIT_FAILED
                    if (!removeAudio && audioFailed) {
                        transformHandler.post { convertVideo(path, id, result, removeAudio = true) }
                    } else {
                        main.post { result.error("convert", exportException.errorCodeName, null) }
                    }
                }
            })
            .build()

        job = Job(transformer, result, part)
        running.remove(id)?.let(::cancel)
        running[id] = job
        try {
            transformer.start(item, part.absolutePath)
            transformHandler.postDelayed(poll, 500)
        } catch (e: Throwable) {
            job.done = true
            running.remove(id)
            part.delete()
            main.post { result.error("convert", e.message ?: e.toString(), null) }
        }
    }
}
