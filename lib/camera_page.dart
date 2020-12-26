import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:first_test_2/display_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CameraPage',
      home: CameraHome(),
    );
  }
}

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  List<CameraDescription> cameras;
  CameraController controller;
  Future<void> _initializeCameraController;
  int selectedCameraIdx;
  String videoPath;

  @override
  // initState
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.massage');
    });
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    await controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  // RecordingButton
  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    });
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
      return null;
    }
    if (controller.value.isRecordingVideo) {
      return null;
    }
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';

    await controller.startVideoRecording(filePath);
    videoPath = filePath;
    return filePath;
  }

  //StopButton
  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      Fluttertoast.showToast(
          msg: 'Video recorded to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayVideoScreen(videoPath),),
      );
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    await controller.stopVideoRecording();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('指タッピング'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _captureControlRowWidget(),
          ),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _captureControlRowWidget() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.videocam),
              color: Colors.teal,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                  ? _onRecordButtonPressed
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.stop),
              color: Colors.red,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      controller.value.isRecordingVideo
                  ? _onStopButtonPressed
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
