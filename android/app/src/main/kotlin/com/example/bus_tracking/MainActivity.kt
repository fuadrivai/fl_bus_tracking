package com.example.bus_tracking

import io.flutter.embedding.android.FlutterActivity

import android.webkit.GeolocationPermissions
import android.webkit.WebChromeClient
import android.webkit.WebView

class MainActivity: FlutterActivity()

class MyWebChromeClient : WebChromeClient() {
    override fun onGeolocationPermissionsShowPrompt(origin: String?, callback: GeolocationPermissions.Callback?) {
        callback?.invoke(origin, true, false)
    }
}
