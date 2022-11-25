import 'package:camera/camera.dart';

import '../models/camera_info.dart';

class CameraService {
  static late CameraInfo _infoModel;
  static CameraInfo info = _infoModel;

  Future<void> init() async {
    final camerasDesc = await availableCameras();

    _infoModel = CameraInfo(camerasDesc: camerasDesc);
  }

  CameraDescription get getFront {
    return _infoModel.camerasDesc.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front);
  }
}
