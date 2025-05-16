// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Common {
  Common._();

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.limited) {
      return true;
    } else if (status == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (status == PermissionStatus.restricted) {
      return true;
    } else {
      return false;
    }
  }

  static Gradient shimmerGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 234, 234, 234),
      Color.fromARGB(255, 202, 202, 202)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.3, 0.9],
  );

  static modalInfo(
    BuildContext context, {
    String? message,
    required String title,
    Widget? icon,
    MODE? mode,
    bool? showAction,
    GestureTapCallback? onTap,
  }) {
    showDialog(
      context: context,
      builder: (__) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 5,
                  left: 8,
                  right: 8,
                ),
                child: Column(
                  children: <Widget>[
                    icon ??
                        FaIcon(
                          mode == MODE.success
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.triangleExclamation,
                          color:
                              mode == MODE.success ? Colors.green : Colors.red,
                          size: 50,
                        ),
                    const SizedBox(height: 10),
                    Text(title, style: const TextStyle(fontSize: 25)),
                    const SizedBox(height: 10),
                    Text(
                      message ?? "Message",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mode == MODE.success ? Colors.green : Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<String?> imageToBase64(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;
    LocationSettings locationSettings;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openLocationSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openLocationSettings();
    }
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  static Stream<Position> getLiveLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    );
  }

  void initBackgroundTracking() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
      // send to server or update UI
    });

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow {applicationName} to access this device's location even when closed or not in use.",
          message:
              "This app collects location data to enable tracking even when the app is closed or not in use.",
          positiveAction: "Change to 'Allow all the time'",
          negativeAction: "Cancel"),
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }
}

enum MODE { success, error }
