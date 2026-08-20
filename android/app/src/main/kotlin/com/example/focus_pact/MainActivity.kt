package com.example.focus_pact

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.focus_pact/kiosk"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startKioskMode" -> {
                    try {
                        startLockTask()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("KIOSK_ERROR", e.message, null)
                    }
                }
                "stopKioskMode" -> {
                    try {
                        stopLockTask()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("KIOSK_ERROR", e.message, null)
                    }
                }
                "isKioskModeActive" -> {
                    try {
                        val activityManager = getSystemService(android.content.Context.ACTIVITY_SERVICE) as android.app.ActivityManager
                        val lockTaskModeState = activityManager.lockTaskModeState
                        val isActive = lockTaskModeState != android.app.ActivityManager.LOCK_TASK_MODE_NONE
                        result.success(isActive)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
