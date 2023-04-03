import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController controller = TextEditingController();
  DateTime dateTime = DateTime.now();
  Duration duration = Duration(minutes: 10);
  List alarmList = [];

  @override
  void initState() {
    super.initState();
    alarmList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorResources.whiteColor,
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.25,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return alarmList[index];
                    },
                    separatorBuilder: (context, ints) {
                      return const Divider(
                          height: 5, color: ColorResources.grey1Color);
                    },
                    itemCount: alarmList.length),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width / 2.5,
                right: MediaQuery.of(context).size.width / 2.3,
                child: FloatingActionButton(
                  onPressed: () {
                    selectTime(context);
                  },
                  backgroundColor: ColorResources.lav2Color,
                  child: const Center(
                      child: Icon(
                    Icons.add,
                    size: 35,
                  )),
                ),
              ),
            ],
          )),
      // ),
    );
  }

  Widget alarmListTile(
      {required String time,
      required String timeRange,
      required String days,
      bool isOn = false}) {
    return ListTile(
      enabled: isOn == false ? true : false,
      contentPadding: const EdgeInsets.all(20),
      title: RichText(
          text: TextSpan(
        text: time,
        style: const TextStyle(fontSize: 40, color: ColorResources.grey1Color),
        children: <TextSpan>[
          TextSpan(text: timeRange, style: const TextStyle(fontSize: 20)),
        ],
      )),
      subtitle: CustomText(days,
          style:
              const TextStyle(fontSize: 15, color: ColorResources.grey3Color)),
      trailing: Switch(
          value: isOn,
          onChanged: (val) {
            setState(() {
              isOn = !isOn;
            });
          }),
    );
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
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          newTime.hour,
          newTime.minute,
        );
        alarmList.add(alarmListTile(
            time: DateFormat("k:mm").format(dateTime),
            timeRange: DateFormat("a").format(dateTime),
            // days: DateFormat("HH:mm").format(dateTime))
            days: "All Days"));
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
