import 'dart:async';

import 'package:camera/camera.dart';
import 'package:first_test_2/list_page.dart';
import 'package:flutter/material.dart';

// List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  final cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('評価アプリ Demo'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                bottom: 15.0,
                right: 15.0,
                child: Text(
                  'presented by YS from ALAN',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Positioned(
                top: 15.0,
                right: 15.0,
                child: Image.asset(
                  'images/logo.png',
                  scale: 3.0,
                ),
              ),
              Center(
                child: SizedBox(
                  width: 120,
                  child: RaisedButton(
                    child: Text(
                      'Start',
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
                          builder: (context) => ListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
