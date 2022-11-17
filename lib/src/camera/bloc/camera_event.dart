part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class OpenCameraEvent extends CameraEvent {
  final CameraType cameraType;

  OpenCameraEvent(this.cameraType);
}

class TakePhotoEvent extends CameraEvent {}
