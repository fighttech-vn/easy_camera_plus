import 'dart:typed_data';

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

  const CameraInfo({
    required this.camerasDesc,
  });
}

class MediaData {
  final String? path;
  final Uint8List? bytes;

  const MediaData({
    this.path,
    this.bytes,
  });
}
