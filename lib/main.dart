import 'dart:io';
import 'package:bus_tracking/injector/injector.dart';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/pages/home/screen/home_v2.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;
late bool cameraPermission;
void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows) {
    cameraPermission = await Common.requestCameraPermission();
    cameras = await availableCameras();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        // useMaterial3: true,
      ),
      home: const HomeV2Screen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
