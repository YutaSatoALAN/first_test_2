import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_test_2/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class DisplayVideoScreen extends StatefulWidget {
  final String filePath;

  DisplayVideoScreen(this.filePath);

  @override
  _DisplayVideoScreenState createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(
      File(widget.filePath),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    Firebase.initializeApp();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '動画確認',
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
            ),
            SizedBox(
              height: 400,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              shape: CircleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonTheme(
                  height: 50,
                  minWidth: 150,
                  child: RaisedButton(
                    child: Text(
                      '再撮影',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.teal,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(),
                        ),
                      );
                    },
                  ),
                ),
                ButtonTheme(
                  height: 50,
                  minWidth: 150,
                  child: RaisedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.teal,
                    textColor: Colors.white,
                    onPressed: () => {
                      videoUpload(),
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void videoUpload() async {
    final String filePath = widget.filePath;
    final Reference ref =
        FirebaseStorage.instance.ref().child('uploads/$filePath');
    // final UploadTask uploadTask = ref.putFile(File(filePath));

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final _flutterVideoCompress = FlutterVideoCompress();
    final info = await _flutterVideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
    );
    debugPrint(info.toJson().toString());

    final UploadTask uploadTask = ref.putFile(info.file);

    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }
}
