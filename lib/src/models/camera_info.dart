import 'package:camera/camera.dart';
enum CameraType {
  photo,
  video,
}

class CameraInfo {
  final List<CameraDescription> camerasDesc;

  CameraInfo({required this.camerasDesc});
}
