// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math' as math;
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/main.dart';
import 'package:bus_tracking/screen/screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? cameraController;
  bool isDetecting = false;

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableTracking: true,
        enableClassification: true),
  );
  // final faceDetector = GoogleMlKit.vision.faceDetector(
  //   FaceDetectorOptions(
  //     enableTracking: true,
  //     enableContours: true,
  //     enableClassification: true,
  //   ),
  // );

  @override
  void initState() {
    initializeCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cameraController != null) {
      final scale = 1 /
          ((cameraController?.value.aspectRatio ?? 0) *
              MediaQuery.of(context).size.aspectRatio);

      return Stack(
        children: [
          cameraPermission
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: CameraPreview(
                      cameraController!,
                    ),
                  ),
                )
              : const Text("Camera Tidak Tersedia"),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              isExtended: true,
              onPressed: () => _takePicture(context),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          )
        ],
      );
    } else {
      return const Center(
        child: Text("No Camera Available"),
      );
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras[1],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await cameraController!.initialize();
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      _startCamera();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _stopCamera();
    faceDetector.close();
    super.dispose();
  }

  _startCamera() async {
    if (cameras.isNotEmpty) {
      if (cameraController != null) {
        cameraController = CameraController(
          cameras[0],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await cameraController?.initialize();
        if (!mounted) {
          return;
        }
        setState(() {});
      }
    }
  }

  _stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  _takePicture(BuildContext context) async {
    if (cameraController == null) return;
    setState(() {});
    final filePicture = await cameraController!.takePicture();
    final file = File(filePicture.path);

    List<String> filePathList = [];
    filePathList.add(file.path.toString());

    final InputImage inputImage = InputImage.fromFile(file);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
    final List<Face> faces = await faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      if (context.mounted) {
        Common.modalInfo(
          context,
          title: "Error",
          mode: MODE.error,
          message: "Pastikan wajah anda tertangkap kamera !",
        );
      }
    } else {
      String? image = await Common.imageToBase64(file.path);
      Session.set("image", image ?? "");
      faceDetector.close();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentScreen()),
            (route) => false);
      }
    }
  }
}
