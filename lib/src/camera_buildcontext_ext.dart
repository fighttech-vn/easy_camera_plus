import 'package:flutter/material.dart';

import '../easy_camera_plus.dart';

extension CameraBuildContextExt on BuildContext {
  Future<T?> startCamera<T>({
    required CameraType cameraType,
    FrameShape? frameShape,
    bool useCameraBack = true,
  }) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameraType: cameraType,
          frameShape: frameShape,
          useCameraBack: useCameraBack,
        ),
      ),
    );
  }
}
