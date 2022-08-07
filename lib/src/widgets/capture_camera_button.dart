import 'package:flutter/material.dart';

typedef CaptureCameraButtonCallback = Function();

/// Camera Action Button
const double sizeRoundedButtonCameraBegin = 64.0;
const double sizeRoundedButtonCameraEnd = 46.0;
const double bottomBodyPosition = 14.0;
const double sizeCameraButtonBegin = 52;
const double sizeCameraButtonEnd = 32;
const double sizeOuterCameraButton = 16;
const double sizeOuterCameraButtonPadding = 5;
const Color grayWhite = Color(0xfff5f5f5);

class CaptureCameraButton extends StatefulWidget {
  final bool isDisabled;
  final CaptureCameraButtonCallback onTap;
  final double? sizeBegin;
  final double? sizeEnd;
  final Duration duration;
  final Color? color;

  const CaptureCameraButton({
    Key? key,
    required this.isDisabled,
    required this.onTap,
    this.duration = const Duration(milliseconds: 200),
    this.sizeBegin,
    this.sizeEnd,
    this.color,
  }) : super(key: key);

  @override
  State<CaptureCameraButton> createState() => _CaptureCameraButtonState();
}

class _CaptureCameraButtonState extends State<CaptureCameraButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  late double _sizeBegin;
  late double _sizeEnd;
  late double _sizeOuterCircle;
  late double _sizeOuterPadding;

  void _sizeInit() {
    _sizeBegin = sizeCameraButtonBegin;
    _sizeEnd = sizeCameraButtonEnd;
    _sizeOuterCircle = _sizeBegin + sizeOuterCameraButton;
    _sizeOuterPadding = sizeOuterCameraButtonPadding;
  }

  void _animationInit() {
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animation = Tween<double>(begin: _sizeBegin, end: _sizeEnd)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      });
  }

  Widget _buildInnerCircle() {
    return Center(
      child: AnimatedContainer(
        width: animation.value,
        height: animation.value,
        duration: widget.duration,
        curve: Curves.linearToEaseOut,
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildOuterCircle() {
    return Center(
      child: Container(
        height: _sizeOuterCircle,
        width: _sizeOuterCircle,
        padding: EdgeInsets.all(_sizeOuterPadding),
        decoration: const BoxDecoration(
          color: grayWhite,
          shape: BoxShape.circle,
        ),
        child: Container(
          height: _sizeBegin,
          width: _sizeBegin,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Future<void> _onTap() async {
    await animationController.forward(from: _sizeBegin);
    widget.onTap.call();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _sizeInit();
    _animationInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _sizeOuterCircle,
      width: _sizeOuterCircle,
      child: AbsorbPointer(
        absorbing: widget.isDisabled,
        child: GestureDetector(
          onTap: widget.isDisabled ? () {} : _onTap,
          child: Stack(children: <Widget>[
            _buildOuterCircle(),
            _buildInnerCircle(),
          ]),
        ),
      ),
    );
  }
}
