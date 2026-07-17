package com.example.patrimonia

import android.app.AppOpsManager
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val screenSecurityChannel = "patrimonia/screen_security"
    private val deviceIntegrityChannel = "patrimonia/device_integrity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            screenSecurityChannel,
        ).setMethodCallHandler { call, result ->
            if (call.method != "setSecure") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val enabled = call.argument<Boolean>("enabled") ?: false
            runOnUiThread {
                if (enabled) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
                result.success(null)
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            deviceIntegrityChannel,
        ).setMethodCallHandler { call, result ->
            if (call.method == "isFakeGpsEnabled") {
                result.success(isFakeGpsEnabled())
            } else {
                result.notImplemented()
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun isFakeGpsEnabled(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return Settings.Secure.getString(
                contentResolver,
                Settings.Secure.ALLOW_MOCK_LOCATION,
            ) == "1"
        }

        val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        return try {
            packageManager.getInstalledApplications(0).any { application ->
                if (application.packageName == packageName) {
                    return@any false
                }

                val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    appOpsManager.unsafeCheckOpNoThrow(
                        AppOpsManager.OPSTR_MOCK_LOCATION,
                        application.uid,
                        application.packageName,
                    )
                } else {
                    appOpsManager.checkOpNoThrow(
                        AppOpsManager.OPSTR_MOCK_LOCATION,
                        application.uid,
                        application.packageName,
                    )
                }
                mode == AppOpsManager.MODE_ALLOWED
            }
        } catch (_: SecurityException) {
            false
        }
    }
}
