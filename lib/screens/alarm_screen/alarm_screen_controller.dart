import 'package:clock_app/module/alram_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlarmScreenController extends GetxController {
  RxList<AlarmModule> aList = <AlarmModule>[].obs;
  DateTime dateTime = DateTime.now();
  Duration duration = const Duration(minutes: 10);

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? newTime = await showRoundedTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        leftBtn: "NOW",
        onLeftBtn: () {
          Navigator.of(context).pop(TimeOfDay.now());
        });
    if (newTime != null) {
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          newTime.hour, newTime.minute);
      aList.addAll([
        AlarmModule(
            hrs: DateFormat("k:mm").format(dateTime),
            mins: DateFormat("a").format(dateTime))
      ]);

      // setAlarm();
    }
  }
}
