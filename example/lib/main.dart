import 'dart:io';

import 'package:easy_camera_plus/easy_camera_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Easy Plus Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Camera Easy Plus Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? imagePath;

  Widget _buildImage() {
    if (imagePath?.contains('/data/user/') == true) {
      return Image.file(
        File(imagePath!),
      );
    }
    return imagePath?.contains('http') == true
        ? Image.network(imagePath!)
        : Image.asset(imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                    builder: (context) =>
                        const CameraScreen(cameraType: CameraType.photo)),
              )
                  .then((value) {
                setState(() {
                  imagePath = value;
                });
              });
            },
            icon: const Icon(Icons.photo_album),
            label: const Text('Take Photo'),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        const CameraScreen(cameraType: CameraType.video)),
              );
            },
            icon: const Icon(Icons.video_camera_back_rounded),
            label: const Text('Record Video'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imagePath != null) _buildImage(),
          ],
        ),
      ),
    );
  }
}
