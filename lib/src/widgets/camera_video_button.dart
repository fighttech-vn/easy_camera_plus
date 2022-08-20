import 'package:flutter/material.dart';

class CameraVideoButton extends StatefulWidget {
  const CameraVideoButton({Key? key}) : super(key: key);

  @override
  State<CameraVideoButton> createState() => _CameraVideoButtonState();
}

class _CameraVideoButtonState extends State<CameraVideoButton> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRecording = !isRecording;
        });
      },
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(width: 4, color: Colors.white)),
        padding: const EdgeInsets.all(2),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isRecording
              ? Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    color: Colors.red,
                  ),
                ),
        ),
      ),
    );
  }
}
