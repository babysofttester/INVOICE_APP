package com.babysoft.invoice_generator

import io.flutter.embedding.android.FlutterActivity
import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    // ★ Must match SafPermissionChannel._channel in the Dart file exactly.
    private val CHANNEL = "com.babysoft.invoice_generator/saf_persist"
    private val REQUEST_CODE_OPEN_TREE = 4201
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickDirectoryAndPersist" -> {
                        pendingResult = result
                        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                            addFlags(
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                            )
                        }
                        startActivityForResult(intent, REQUEST_CODE_OPEN_TREE)
                    }
                    "persistUriPermission" -> {
                        val uriString = call.argument<String>("uri")
                        if (uriString == null) {
                            result.error("NO_URI", "uri argument missing", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = Uri.parse(uriString)
                            contentResolver.takePersistableUriPermission(
                                uri,
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                            )
                            result.success(true)
                        } catch (e: SecurityException) {
                            result.error("PERSIST_FAILED", e.message, null)
                        }
                    }
                    "hasPersistedPermission" -> {
                        val uriString = call.argument<String>("uri")
                        val has = contentResolver.persistedUriPermissions.any {
                            it.uri.toString() == uriString && it.isReadPermission && it.isWritePermission
                        }
                        result.success(has)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // ★ FIXED — the previous version tried to implement
    // `PluginRegistry.ActivityResultListener` (returns Boolean) on the
    // SAME method as Activity's real `onActivityResult` (returns
    // Unit/void). That's a signature conflict and would not compile.
    // It also called `addActivityResultListener(this)`, which isn't a
    // valid method on FlutterActivity directly.
    //
    // Correct approach: override the real onActivityResult, call
    // super() first so other plugins (share_plus, url_launcher,
    // image_picker, etc.) still get their own results delivered, then
    // handle your own request code.
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_CODE_OPEN_TREE) {
            val result = pendingResult
            pendingResult = null
            if (resultCode == Activity.RESULT_OK && data?.data != null) {
                val treeUri: Uri = data.data!!
                try {
                    contentResolver.takePersistableUriPermission(
                        treeUri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    )
                    result?.success(treeUri.toString())
                } catch (e: SecurityException) {
                    result?.error("PERSIST_FAILED", e.message, null)
                }
            } else {
                result?.success(null) // user cancelled the picker
            }
        }
    }
}