import 'dart:async';

import 'package:clock_app/module/timer_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimerScreenController extends GetxController {
  TextEditingController hrsController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  RxList<TimerModule> timesList = <TimerModule>[].obs;
  RxList<Timer> countdownTimerList = <Timer>[].obs;
  RxList<Duration> durationList = <Duration>[].obs;



}
