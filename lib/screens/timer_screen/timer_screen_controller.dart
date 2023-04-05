import 'dart:async';

import 'package:clock_app/module/timer_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimerScreenController extends GetxController with StateMixin {
  TextEditingController hrsController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  RxList<TimerModule> timesList = <TimerModule>[].obs;
  RxList<Timer> countdownTimerList = <Timer>[].obs;
  RxList<Duration> durationList = <Duration>[].obs;

  void startTimer(int index) {
    if (countdownTimerList.value.isNotEmpty) {
      countdownTimerList.value[index].cancel();
    }
    countdownTimerList.value[index] =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      setCountDown(durations: durationList.value[index], index: index);
    });
  }

  void stopTimer(int index) {
    countdownTimerList.value[index].cancel();
  }

  void setCountDown({required Duration durations, required index}) {
    final sec = durations!.inSeconds - 1;
    if (sec < 0) {
      countdownTimerList.value[index].cancel();
    } else {
      durations = Duration(seconds: sec.toInt());
      durationList.value[index] = durations;
      update();
    }
  }
}
