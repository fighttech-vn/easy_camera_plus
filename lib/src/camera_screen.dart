import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'services/device_service.dart';
import 'widgets/frame_layout.dart';

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

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    await controller?.dispose();

    controller =
        CameraController(cameraDescription, ResolutionPreset.ultraHigh);

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

  // void _onSwitchCamera() {
  //   selectedCameraIdx =
  //       selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
  //   final selectedCamera = cameras[selectedCameraIdx];

  //   _onCameraSwitched(selectedCamera);

  //   setState(() {
  //     selectedCameraIdx = selectedCameraIdx;
  //   });
  // }

  // void _onRecordButtonPressed() {
  //   _startVideoRecording().then((String? filePath) {
  //     if (filePath != null) {
  //       showMessage('Recording video started');
  //     }
  //   });
  // }

  // void _onStopButtonPressed() {
  //   _stopVideoRecording().then((_) {
  //     showMessage('Video recorded to $videoPath');
  //   });
  // }

  // ignore: unused_element
  Future<String?> _startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showMessage('Please wait');
      return null;
    }

    // Do nothing if a recording is on progress
    if (cameraController.value.isRecordingVideo) {
      return null;
    }

    final filePath = await DeviceService().createPath();

    try {
      await cameraController.startVideoRecording();
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<String?> _onTakePhoto() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      final file = await cameraController.takePicture();
      return file.path;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Future<void> _stopVideoRecording() async {
  //   try {
  //     if (controller == null || !controller!.value.isRecordingVideo) {
  //       return;
  //     }

  //     await controller?.stopVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return;
  //   }
  // }

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

  // IconData _getCameraLensIcon(CameraLensDirection direction) {
  //   switch (direction) {
  //     case CameraLensDirection.back:
  //       return Icons.camera_rear;
  //     case CameraLensDirection.front:
  //       return Icons.camera_front;
  //     case CameraLensDirection.external:
  //       return Icons.camera;
  //     default:
  //       return Icons.device_unknown;
  //   }
  // }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null) {
      return const SizedBox();
    }

    if (!controller!.value.isInitialized) {
      return const SizedBox();
    }

    final mediaSize = MediaQuery.of(context).size;
    final scale = 1 / (controller!.value.aspectRatio * mediaSize.aspectRatio);

    final cameraPreview = CameraPreview(controller!);

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
    return Material(
      child: _initialDone == false
          ? const Center(child: CircularProgressIndicator())
          : FrameLayoutWidget(
              onTakePhoto: () {
                _onTakePhoto().then((value) {
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  }
                });
              },
              child: controller != null
                  ? _cameraPreviewWidget()
                  : const SizedBox(),
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
