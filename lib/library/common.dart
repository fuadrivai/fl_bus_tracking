import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
}

enum MODE { success, error }
