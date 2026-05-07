package com.example.foodie_finder

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "foodie_finder/native_config",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getGoogleApiKey" -> {
                    val resourceId = resources.getIdentifier(
                        "google_api_key",
                        "string",
                        packageName,
                    )
                    val apiKey = if (resourceId != 0) getString(resourceId) else null
                    if (apiKey.isNullOrBlank()) {
                        result.error(
                            "missing_google_api_key",
                            "Google API key resource was not found.",
                            null,
                        )
                    } else {
                        result.success(apiKey)
                    }
                }
                "getDefaultWebClientId" -> {
                    val resourceId = resources.getIdentifier(
                        "default_web_client_id",
                        "string",
                        packageName,
                    )
                    val clientId = if (resourceId != 0) getString(resourceId) else null
                    if (clientId.isNullOrBlank()) {
                        result.success(null)
                    } else {
                        result.success(clientId)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
