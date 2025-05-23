import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    Widget? buttonAction,
    MODE? mode,
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
                    buttonAction ??
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
    // final file = File(imagePath);
    var result = await FlutterImageCompress.compressWithFile(
      File(imagePath).absolute.path,
      minWidth: 1000,
      minHeight: 500,
      quality: 94,
      // rotate: 90,
    );
    return base64Encode(result as List<int>);
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
}

enum MODE { success, error }
