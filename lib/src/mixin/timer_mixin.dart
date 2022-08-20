// Copyright 2021 Fighttech.vn, Ltd. All rights reserved.

import 'dart:async';

import 'package:flutter/material.dart';


mixin TimerMixin<T extends StatefulWidget> on State<T> {
  bool get isCountDown;

  int get timeInputLimit;

  void onCompleteTimer();

  late ValueNotifier<int> timeCtr;
  late Timer _timer;

  bool _isStart = false;
  int? _time;

  @override
  void initState() {
    super.initState();

    _time = DateTimeHelper.timestamp + timeInputLimit;

    if (isCountDown && _time != null) {
      timeCtr = ValueNotifier<int>(timeInputLimit);
    } else {
      timeCtr = ValueNotifier<int>(0);
    }
  }

  @override
  void dispose() {
    if (_isStart) {
      _timer.cancel();
    }

    super.dispose();
  }

  void startTimer() {
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
              timeCtr.value = startTime - DateTimeHelper.timestamp;
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
            timeCtr.value = (DateTimeHelper.timestamp - ti) + 1;
          }
        },
      );
    }
  }
}
class DateTimeHelper {
  static int get timestamp => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
