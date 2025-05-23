import 'dart:io';
import 'package:bus_tracking/injector/injector.dart';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/pages/screen.dart';
import 'package:bus_tracking/widget/widget.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool>? isLogin;

  @override
  void initState() {
    isLogin = Session.checkValue("isLogin");
    super.initState();
  }

  Widget navigation(bool login) {
    if (login) {
      return StudentScreen(isLogin: login.toString());
    } else {
      return const HomeV2Screen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Bus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        // useMaterial3: true,
      ),
      home: ExitConfirmationWrapper(
        child: FutureBuilder(
          future: isLogin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(5, (index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8,
                    ),
                    child: StudentShimmer(),
                  );
                }).toList(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return navigation(snapshot.data ?? false);
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
