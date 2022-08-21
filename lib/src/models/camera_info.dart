import 'package:camera/camera.dart';

enum CameraType {
  photo,
  video,
}
enum FrameShape {
  circle,
  rectangle,
}
class CameraInfo {
  final List<CameraDescription> camerasDesc;

  CameraInfo({required this.camerasDesc});
}
