import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/camera_info.dart';
import 'camera_video_button.dart';
import 'capture_camera_button.dart';

class FrameLayoutWidget extends StatefulWidget {
  final Widget child;
  final Function onTakePhoto;
  final CameraType cameraType;

  const FrameLayoutWidget({
    Key? key,
    required this.child,
    required this.onTakePhoto,
    required this.cameraType,
  }) : super(key: key);

  @override
  State<FrameLayoutWidget> createState() => _FrameLayoutWidgetState();
}

class _FrameLayoutWidgetState extends State<FrameLayoutWidget> {
  /// Display a row of toggle to select the camera
  ///  (or a message if no camera is available).
  // Widget _cameraTogglesRowWidget() {

  //   final selectedCamera = cameras[selectedCameraIdx];
  //   final lensDirection = selectedCamera.lensDirection;

  //   return TextButton.icon(
  //     onPressed: _onSwitchCamera,
  //     icon: Icon(_getCameraLensIcon(lensDirection)),
  //     label: Text(
  //       lensDirection
  //           .toString()
  //           .substring(lensDirection.toString().indexOf('.') + 1),
  //     ),
  //   );
  // }

  // /// Display the control bar with buttons to record videos.
  // Widget _captureControlRowWidget() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     mainAxisSize: MainAxisSize.max,
  //     children: <Widget>[
  //       IconButton(
  //         icon: const Icon(Icons.videocam),
  //         color: Colors.blue,
  //         onPressed: controller!.value.isInitialized &&
  //                 !controller!.value.isRecordingVideo
  //             ? _onRecordButtonPressed
  //             : null,
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.stop),
  //         color: Colors.red,
  //         onPressed: controller!.value.isInitialized &&
  //                 controller!.value.isRecordingVideo
  //             ? _onStopButtonPressed
  //             : null,
  //       )
  //     ],
  //   );
  // }
  late CameraType cameraType;

  void _onTapTake() {
    widget.onTakePhoto();
  }

  @override
  void initState() {
    cameraType = widget.cameraType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          widget.child,
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/frame_preview_card.svg',
              package: 'easy_camera_plus',
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: const Color(0xFF1A2B61),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: CameraType.values
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cameraType = e;
                                      });
                                    },
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minWidth: 88, minHeight: 33),
                                      decoration: cameraType != e
                                          ? null
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                  color: Colors.white)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        e.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 13,
                                              letterSpacing: -0.3,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 50,
                              child: GestureDetector(
                                onTap: Navigator.of(context).pop,
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              firstChild: CaptureCameraButton(
                                isDisabled: false,
                                onTap: _onTapTake,
                              ),
                              secondChild: const CameraVideoButton(),
                              crossFadeState: cameraType == CameraType.photo
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                            ),
                            SizedBox(
                              width: 50,
                              child: GestureDetector(
                                onTap: Navigator.of(context).pop,
                                child: const Icon(
                                  CupertinoIcons.camera_rotate,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(
          //     top: MediaQuery.of(context).padding.top + 24,
          //   ),
          //   child: GestureDetector(
          //     onTap: Navigator.of(context).pop,
          //     child: Container(
          //       width: 32,
          //       height: 32,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(16),
          //         border: Border.all(color: Colors.white),
          //       ),
          //       child: const Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: 26,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
