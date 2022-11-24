// Copyright 2021 Fighttech.vn, Ltd. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';

mixin TimerMixin<T extends StatefulWidget> on State<T> {
  //  ------------ Input ------------
  bool get isCountDown;

  int get timeInputLimit;

  void onCompleteTimer();
  //  ------------ Input DONE ------------

  final ValueNotifier<int> timeCtr = ValueNotifier<int>(0);
  late Timer _timer;

  bool _isStart = false;
  int? _time;

  int get _timestampNow => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  bool get isActiveTimer => _timer.isActive;

  @override
  void initState() {
    super.initState();

    _initTimer();
  }

  void _initTimer() {
    _time = _timestampNow + timeInputLimit;

    if (isCountDown && _time != null) {
      timeCtr.value = timeInputLimit;
    } else {
      timeCtr.value = 0;
    }
  }

  @override
  void dispose() {
    if (_isStart) {
      _timer.cancel();
    }
    super.dispose();
  }

//  ------------ Output ------------
  void startTimer() {
    _initTimer();
    _isStart = true;

    if (isCountDown && _time != null) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (timeCtr.value == 0) {
            timer.cancel();
            onCompleteTimer();
          } else {
            final startTime = _time;
            if (startTime != null) {
              timeCtr.value = startTime - _timestampNow;
            }
          }
        },
      );
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          final ti = _time;
          if (ti != null) {
            timeCtr.value = (_timestampNow - ti) + 1;
          }
        },
      );
    }
  }

  Widget builderTimer(ValueWidgetBuilder<int> builder) =>
      ValueListenableBuilder<int>(
        valueListenable: timeCtr,
        builder: (context, value, child) {
          return builder(context, value, child);
        },
      );
  //  ------------ Output DONE ------------
}
