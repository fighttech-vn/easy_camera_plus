import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'capture_camera_button.dart';

class FrameLayoutWidget extends StatefulWidget {
  final Widget child;
  final Function onTakePhoto;

  const FrameLayoutWidget({
    Key? key,
    required this.child,
    required this.onTakePhoto,
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

  void _onTapTake() {
    widget.onTakePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            minimum: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  CaptureCameraButton(
                    isDisabled: false,
                    onTap: _onTapTake,
                  ),
                  // _cameraTogglesRowWidget(),
                  // _captureControlRowWidget(),
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
