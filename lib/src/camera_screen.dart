import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../easy_camera_plus.dart';
import 'services/device_service.dart';
import 'widgets/frame_layout.dart';

class CameraScreen extends StatefulWidget {
  final CameraType cameraType;
  final FrameShape? frameShape;

  const CameraScreen({
    Key? key,
    required this.cameraType,
    this.frameShape,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String? videoPath;
  List<CameraController> controllers = [];
  List<CameraDescription> cameras = [];
  late int selectedCameraIdx;

  bool isDoneInit = false;

  @override
  void initState() {
    CameraService().init().then((value) {
      controllers.addAll(CameraService.info.camerasDesc
          .map((e) => CameraController(e, ResolutionPreset.veryHigh,
              enableAudio: false))
          .toList());

      controller = controllers.first;
      controller?.initialize().then((value) {
        setState(() {
          isDoneInit = true;
        });
      });
    });

    super.initState();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

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
    if (cameraController == null) {
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
    try {
      if (controller == null) {
        return null;
      }
      if (controller!.value.isTakingPicture) {
        // A capture is already pending, do nothing.
        return null;
      }
      final file = await controller!.takePicture();
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

  Widget _cameraPreviewWidget() {
    if (controller == null) {
      return const SizedBox();
    }
    final cameraPreview = AspectRatio(
      aspectRatio: 1 / controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: cameraPreview,
    );
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FrameLayoutWidget(
      frameShape: widget.frameShape,
      cameraType: widget.cameraType,
      onTakePhoto: () {
        _onTakePhoto().then((value) {
          if (value != null) {
            Navigator.of(context).pop(value);
          }
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _cameraPreviewWidget(),
      ),
    );
  }
}
