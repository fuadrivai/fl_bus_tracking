import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "";
  InAppWebViewController? webViewController;
  bool loading = true;
  @override
  void initState() {
    getDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Child & Driver Tracking"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(url),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                  origin: origin,
                  allow: true,
                  retain: true,
                );
              },
            ),
    );
  }

  getDeviceId() async {
    loading = true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    setState(() {
      url =
          "https://script.google.com/macros/s/AKfycbznjNorSdw3iv-WNE9k7D3BgFANzYncz_Tvp7dPAdXhK1F7UndZbCNfX35ilzsGmKysTA/exec?deviceid=${androidInfo.id}";
      loading = false;
    });
  }
}
