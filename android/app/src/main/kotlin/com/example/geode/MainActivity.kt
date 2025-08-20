package com.example.geode

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.geode/bloker"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { 
            call, result ->
             if (call.method == "updateBlocklist") {
                val apps = call.argument<List<String>>("apps")
                val websites = call.argument<List<String>>("websites")
                if (apps != null && websites != null) {
                    GeodeAccessibilityService.blockedApps = apps
                    GeodeAccessibilityService.blockedWebsites = websites
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Missing arguments", null)
                }
            } else {
                result.notImplemented()
            }
        }
        }
    }
}