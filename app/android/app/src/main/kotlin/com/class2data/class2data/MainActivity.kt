package com.class2data.class2data

import android.content.ContentUris
import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.class2data.class2data/backup_storage"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToDownloads" -> {
                        val fileName = call.argument<String>("fileName")!!
                        val sourcePath = call.argument<String>("sourceFilePath")!!
                        saveToDownloads(fileName, sourcePath, result)
                    }
                    "getBackupDirPath" -> {
                        getBackupDirPath(result)
                    }
                    "getLatestBackupInfo" -> {
                        getLatestBackupInfo(result)
                    }
                    "openInFileManager" -> {
                        val dirPath = call.argument<String>("dirPath")!!
                        openInFileManager(dirPath, result)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getBackupDirPath(result: MethodChannel.Result) {
        val dir = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            "kexiaoji/backup",
        )
        result.success(dir.absolutePath)
    }

    private fun getLatestBackupInfo(result: MethodChannel.Result) {
        try {
            val relativePath = "${Environment.DIRECTORY_DOWNLOADS}/kexiaoji/backup"

            var selection = "${MediaStore.Downloads.RELATIVE_PATH} = ? AND ${MediaStore.Downloads.MIME_TYPE} = ?"
            val selectionArgs = mutableListOf("$relativePath/", "application/zip")

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                selection += " AND ${MediaStore.Downloads.IS_TRASHED} = 0"
            }

            val sortOrder = "${MediaStore.Downloads.DATE_MODIFIED} DESC"

            val cursor = contentResolver.query(
                MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                arrayOf(
                    MediaStore.Downloads._ID,
                    MediaStore.Downloads.DISPLAY_NAME,
                    MediaStore.Downloads.SIZE,
                    MediaStore.Downloads.DATE_MODIFIED,
                    MediaStore.Downloads.DATA,
                ),
                selection,
                selectionArgs.toTypedArray(),
                sortOrder,
            )

            if (cursor == null) {
                result.success(null)
                return
            }

            cursor.use {
                while (it.moveToNext()) {
                    val id = it.getLong(it.getColumnIndexOrThrow(MediaStore.Downloads._ID))
                    val name = it.getString(it.getColumnIndexOrThrow(MediaStore.Downloads.DISPLAY_NAME))
                    val size = it.getLong(it.getColumnIndexOrThrow(MediaStore.Downloads.SIZE))
                    val dateModified = it.getLong(it.getColumnIndexOrThrow(MediaStore.Downloads.DATE_MODIFIED))
                    val dataPath = it.getString(it.getColumnIndexOrThrow(MediaStore.Downloads.DATA))

                    // 通过 ContentResolver 验证文件真正可读（排除已删除/回收站幽灵记录）
                    val contentUri = ContentUris.withAppendedId(
                        MediaStore.Downloads.EXTERNAL_CONTENT_URI, id,
                    )
                    try {
                        contentResolver.openInputStream(contentUri)?.close()
                    } catch (_: Exception) {
                        continue
                    }

                    val info = hashMapOf<String, Any>(
                        "name" to name,
                        "size" to size,
                        "lastModified" to dateModified * 1000L,
                        "path" to dataPath,
                    )
                    result.success(info)
                    return
                }
            }
            result.success(null)
        } catch (e: Exception) {
            result.success(null)
        }
    }

    private fun saveToDownloads(
        fileName: String,
        sourcePath: String,
        result: MethodChannel.Result,
    ) {
        try {
            val sourceFile = File(sourcePath)
            if (!sourceFile.exists()) {
                result.error("FILE_NOT_FOUND", "源文件不存在: $sourcePath", null)
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val values = ContentValues().apply {
                    put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                    put(MediaStore.Downloads.MIME_TYPE, getMimeType(fileName))
                    put(
                        MediaStore.Downloads.RELATIVE_PATH,
                        "${Environment.DIRECTORY_DOWNLOADS}/kexiaoji/backup",
                    )
                }
                val uri = contentResolver.insert(
                    MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                    values,
                )
                if (uri == null) {
                    result.error("INSERT_FAILED", "无法创建文件", null)
                    return
                }
                contentResolver.openOutputStream(uri)?.use { out ->
                    sourceFile.inputStream().use { it.copyTo(out) }
                }
                sourceFile.delete()
                val dir = File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    "kexiaoji/backup",
                )
                result.success(File(dir, fileName).absolutePath)
            } else {
                val dir = File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    "kexiaoji/backup",
                )
                if (!dir.exists()) dir.mkdirs()
                val target = File(dir, fileName)
                sourceFile.copyTo(target, overwrite = true)
                sourceFile.delete()
                result.success(target.absolutePath)
            }
        } catch (e: Exception) {
            result.error("SAVE_FAILED", e.message, null)
        }
    }

    private fun openInFileManager(
        dirPath: String,
        result: MethodChannel.Result,
    ) {
        try {
            val dir = File(dirPath)
            if (!dir.exists()) dir.mkdirs()

            // 方案1：DocumentsUI + vnd.android.document/directory
            try {
                val docUri = Uri.parse(
                    "content://com.android.externalstorage.documents/document/primary%3ADownload%2Fkexiaoji%2Fbackup"
                )
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    setDataAndType(docUri, "vnd.android.document/directory")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    result.success(true)
                    return
                }
            } catch (_: Exception) {}

            // 方案2：FileProvider + resource/folder（部分文件管理器支持）
            try {
                val uri = FileProvider.getUriForFile(
                    this,
                    "${applicationContext.packageName}.fileprovider",
                    dir,
                )
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    setDataAndType(uri, "resource/folder")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    result.success(true)
                    return
                }
            } catch (_: Exception) {}

            // 无法打开目录，返回 false 让 Flutter 侧展示路径提示
            result.success(false)
        } catch (e: Exception) {
            result.error("OPEN_FAILED", e.message, null)
        }
    }

    private fun getMimeType(fileName: String): String {
        val extension = fileName.substringAfterLast('.', "")
        return MimeTypeMap.getSingleton()
            .getMimeTypeFromExtension(extension) ?: "application/octet-stream"
    }
}
