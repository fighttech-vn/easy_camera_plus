import 'package:flutter/material.dart';

import '../easy_camera_plus.dart';

extension CameraBuildContextExt on BuildContext {
  Future<T?> startCamera<T>({
    required CameraType cameraType,
    FrameShape? frameShape,
    bool useCameraBack = true,
    bool showFlashButton = true,
  }) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameraType: cameraType,
          frameShape: frameShape,
          useCameraBack: useCameraBack,
          showFlashButton: showFlashButton,
        ),
      ),
    );
  }

  Future<T?> takePhotoAvatar<T>({
    bool showFlashButton = false,
  }) async {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameraType: CameraType.photo,
          frameShape: FrameShape.circle,
          showFlashButton: showFlashButton,
        ),
      ),
    );
  }
}
