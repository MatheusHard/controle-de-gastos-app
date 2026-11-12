package com.example.controle_de_gastos_app

import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.pdf.PdfRenderer
import android.os.ParcelFileDescriptor
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import kotlin.concurrent.thread
import kotlin.math.roundToInt

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "controle_de_gastos/shared_pdf",
        ).setMethodCallHandler { call, result ->
            val path = call.argument<String>("path")
            when {
                call.method != "renderFirstPage" -> result.notImplemented()
                path.isNullOrBlank() -> result.error("INVALID_PATH", null, null)
                else -> thread {
                    try {
                        val preview = renderFirstPage(File(path))
                        runOnUiThread { result.success(preview.path) }
                    } catch (error: Exception) {
                        runOnUiThread { result.error("PDF_RENDER_FAILED", error.message, null) }
                    }
                }
            }
        }
    }

    private fun renderFirstPage(pdf: File): File {
        val descriptor = ParcelFileDescriptor.open(pdf, ParcelFileDescriptor.MODE_READ_ONLY)
        val renderer = try {
            PdfRenderer(descriptor)
        } catch (error: Exception) {
            descriptor.close()
            throw error
        }

        renderer.use {
            renderer.openPage(0).use { page ->
                val scale = 1600f / maxOf(page.width, page.height)
                val bitmap = Bitmap.createBitmap(
                    (page.width * scale).roundToInt().coerceAtLeast(1),
                    (page.height * scale).roundToInt().coerceAtLeast(1),
                    Bitmap.Config.ARGB_8888,
                )
                try {
                    bitmap.eraseColor(Color.WHITE)
                    val transform = Matrix().apply { setScale(scale, scale) }
                    page.render(bitmap, null, transform, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
                    val preview = File.createTempFile("shared_pdf_", ".jpg", cacheDir)
                    try {
                        preview.outputStream().use {
                            check(bitmap.compress(Bitmap.CompressFormat.JPEG, 90, it))
                        }
                        return preview
                    } catch (error: Exception) {
                        preview.delete()
                        throw error
                    }
                } finally {
                    bitmap.recycle()
                }
            }
        }
    }
}
