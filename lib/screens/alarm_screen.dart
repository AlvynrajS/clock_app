
import 'package:clock_app/module/alram_module.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen>
    with AutomaticKeepAliveClientMixin {
  DateTime dateTime = DateTime.now();
  Duration duration = const Duration(minutes: 10);
  List<AlarmModule> aList = [];
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
                    if (value != null) {
                      setState(() {
                        selectedWeekdays[index] = value;
                      });
                    } else {
                      selectedWeekdays[index];
                    }
                  },
                );
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 1.3,
        child: ListView.separated(
          itemCount: aList.length,
          itemBuilder: (context, index) {
            return ListTile(
                contentPadding: const EdgeInsets.all(20),
                title: RichText(
                    text: TextSpan(
                        text: aList[index].hrs,
                        style: const TextStyle(
                            fontSize: 40, color: ColorResources.grey1Color),
                        children: [
                      const TextSpan(
                          text: "  ", style: TextStyle(fontSize: 20)),
                      TextSpan(
                          text: aList[index].mins,
                          style: const TextStyle(fontSize: 20))
                    ])),
                subtitle: CustomText(days.join(','),
                    style: const TextStyle(
                        fontSize: 15, color: ColorResources.grey3Color)),
                trailing: Switch(
                    value: aList[index].isOn,
                    onChanged: (val) {
                      setState(() {
                        aList[index].isOn = val;
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
          selectTime(context);
        },
        child: const Icon(Icons.add),
      )
    ]);
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? newTime = await showRoundedTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        leftBtn: "NOW",
        onLeftBtn: () {
          Navigator.of(context).pop(TimeOfDay.now());
        });
    if (newTime != null) {
      setState(() {
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            newTime.hour, newTime.minute);
        aList.addAll([
          AlarmModule(
              hrs: DateFormat("k:mm").format(dateTime),
              mins: DateFormat("a").format(dateTime))
        ]);

        setAlarm();
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
