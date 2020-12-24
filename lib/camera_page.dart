import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  Future<void> _setupCameras() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    controller = new CameraController(firstCamera, ResolutionPreset.max);
    _initializeCameraController = controller.initialize();
    setState(() {});
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
        title: Text('test'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: FutureBuilder<void>(
            future: _initializeCameraController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.teal,
        onPressed: () async {
          try {
            final path = join(
              (await getApplicationDocumentsDirectory()).path,
              '${DateTime.now()}.png',
            );
            await controller.takePicture(path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
