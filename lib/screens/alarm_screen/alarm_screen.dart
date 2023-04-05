import 'package:clock_app/module/alram_module.dart';
import 'package:clock_app/screens/alarm_screen/alarm_screen_controller.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen>
    with AutomaticKeepAliveClientMixin {
  AlarmScreenController controller = Get.put(AlarmScreenController());


  List<String> days = [];
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<bool> selectedWeekdays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Future<void> setAlarm() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select weekdays'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: weekdays.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                    title: Text(weekdays[index]),
                    value: selectedWeekdays[index],
                    onChanged: (bool? value) {
                      isChecked(value!, index);
                    });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                List<String> selectedDays = [];
                for (int i = 0; i < weekdays.length; i++) {
                  if (selectedWeekdays[i]) {
                    selectedDays.add(weekdays[i]);
                    days.addAll([weekdays[i]]);
                  }
                }
                setState(() {
                  selectedDays;
                  days;
                });
                // TODO: Schedule the alarm for the selected days
              },
            ),
          ],
        );
      },
    );
  }

  void isChecked(bool newValue, int index) =>
      setState(() {
        selectedWeekdays[index] = newValue;

        if (selectedWeekdays[index]) {
          //something here
        } else {
          // change value here
        }

        // if (value != null) {
        //   setState(() {
        //     selectedWeekdays[index] = value;
        //   });
        // } else {
        //   selectedWeekdays[index];
        // }
      });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmScreenController>(
      builder: (controller) {
        return Obx(() {
          return Column(children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 1.3,
              child: ListView.separated(
                itemCount: controller.aList.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: RichText(
                          text: TextSpan(
                              text: controller.aList[index].hrs,
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: ColorResources.grey1Color),
                              children: [
                                const TextSpan(
                                    text: "  ", style: TextStyle(fontSize: 20)),
                                TextSpan(
                                    text: controller.aList[index].mins,
                                    style: const TextStyle(fontSize: 20))
                              ])),
                      subtitle: CustomText(days.join(','),
                          style: const TextStyle(
                              fontSize: 15, color: ColorResources.grey3Color)),
                      trailing: Switch(
                          value: controller.aList[index].isOn,
                          onChanged: (val) {
                            setState(() {
                              controller.aList[index].isOn = val;
                            });
                          }));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 10,
                    color: ColorResources.grey1Color,
                  );
                },
              ),
            ),
            FloatingActionButton(
              backgroundColor: ColorResources.lav2Color,
              onPressed: () {
                controller.selectTime(context);
              },
              child: const Icon(Icons.add),
            )
          ]);
        });
      },
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
