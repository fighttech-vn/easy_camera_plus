import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  var _initialDone = false;
  CameraController? controller;
  String? videoPath;
  List<CameraController> controllers = [];
  List<CameraDescription> cameras = [];
  late int selectedCameraIdx;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
        setState(() {
          _initialDone = true;
        });
      }
    }).catchError((err) {
      log('Error: $err.code\nError Message: $err.message');
    });
  }

  /// Display a row of toggle to select the camera
  ///  (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras.isEmpty) {
      return Row();
    }

    final selectedCamera = cameras[selectedCameraIdx];
    final lensDirection = selectedCamera.lensDirection;

    return TextButton.icon(
      onPressed: _onSwitchCamera,
      icon: Icon(_getCameraLensIcon(lensDirection)),
      label: Text(
        lensDirection
            .toString()
            .substring(lensDirection.toString().indexOf('.') + 1),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller!.value.isInitialized &&
                  !controller!.value.isRecordingVideo
              ? _onRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller!.value.isInitialized &&
                  controller!.value.isRecordingVideo
              ? _onStopButtonPressed
              : null,
        )
      ],
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    await controller?.dispose();

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller?.value.hasError ?? true) {
        showMessage('Camera error ${controller?.value.errorDescription}');
      }
    });

    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    final selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String? filePath) {
      if (filePath != null) {
        showMessage('Recording video started');
      }
    });
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      showMessage('Video recorded to $videoPath');
    });
  }

  Future<String?> _startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      showMessage('Please wait');
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller!.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await controller?.startVideoRecording();
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    try {
      if (controller == null) {
        return;
      }

      if (!controller!.value.isRecordingVideo) {
        return;
      }
      await controller?.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void _showCameraException(CameraException e) {
    final String errorText =
        'Error: ${e.code}\nError Message: ${e.description}';
    log(errorText);

    showMessage('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null) {
      return const SizedBox();
    }

    if (!controller!.value.isInitialized) {
      return const CircularProgressIndicator();
    }

    final mediaSize = MediaQuery.of(context).size;
    final scale = 1 / (controller!.value.aspectRatio * mediaSize.aspectRatio);

    final cameraPreview = CameraPreview(
      controller!,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _cameraTogglesRowWidget(),
              _captureControlRowWidget(),
            ],
          ),
        ),
      ),
    );

    return ClipRect(
      clipper: _MediaSizeClipper(mediaSize),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: cameraPreview,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _initialDone == false
          ? const Text('initing')
          : Stack(
              children: <Widget>[
                if (controller != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: controller!.value.isRecordingVideo
                            ? Colors.redAccent
                            : Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: _cameraPreviewWidget(),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;

  const _MediaSizeClipper(this.mediaSize);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
