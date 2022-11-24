import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/camera_info.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial()) {
    on<OpenCameraEvent>(_onOpenCameraEvent);
    on<TakePhotoEvent>(_onTakePhotoEvent);
  }

  FutureOr<void> _onTakePhotoEvent(
      TakePhotoEvent event, Emitter<CameraState> emit) {}

  FutureOr<void> _onOpenCameraEvent(
      OpenCameraEvent event, Emitter<CameraState> emit) {}
}
