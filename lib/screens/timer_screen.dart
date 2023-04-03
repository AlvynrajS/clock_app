import 'dart:async';
import 'dart:core';
import 'package:clock_app/module/timer_module.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/validation.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with AutomaticKeepAliveClientMixin {
  List<TimerModule> timesList = [];
  TextEditingController hrsController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Timer? countdownTimer;
  Duration? myDuration;

  String hrStrDigits(int n) => n.toString().padLeft(2, '0');
  String minStrDigits(int n) => n.toString().padLeft(2, '0');
  String secStrDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timesList;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.whiteColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Recent items",
                style: const TextStyle(
                    color: ColorResources.grey1Color, fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/1.3,
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount: timesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return timerListTile(
                            durations: Duration(
                                hours: int.parse(timesList[index].hrs),
                                minutes: int.parse(timesList[index].min),
                                seconds: int.parse(timesList[index].sec)),
                            cityName: timesList[index].cityName,
                            sec: Duration(
                                    hours: int.parse(timesList[index].hrs),
                                    minutes: int.parse(timesList[index].min),
                                    seconds: int.parse(timesList[index].sec))
                                .inSeconds,
                            onPress: () {
                              (timesList[index].isPlaying == false)
                                  ? startTimer()
                                  : stopTimer();
                              setState(() {
                                timesList[index].isPlaying =
                                    !timesList[index].isPlaying;
                              });
                            },
                            isPlay: timesList[index].isPlaying);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 1,
                          color: ColorResources.grey1Color,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width/2.5,
                      child: FloatingActionButton(
                        onPressed: () {
                          popup();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerListTile(
      {required Duration durations,
      required String cityName,
      required int sec,
      required Function() onPress,
      bool isPlay = false}) {
    var hours;
    var minutes;
    var seconds;
    if (durations != null) {
      myDuration = durations;
      hours = hrStrDigits(myDuration!.inHours.remainder(24));
      minutes = minStrDigits(myDuration!.inMinutes.remainder(60));
      seconds = secStrDigits(myDuration!.inSeconds.remainder(60));
    } else {
      myDuration = Duration(hours: 10);
      hours = hrStrDigits(myDuration!.inHours.remainder(24));
      minutes = minStrDigits(myDuration!.inMinutes.remainder(60));
      seconds = secStrDigits(myDuration!.inSeconds.remainder(60));
    }
    return ListTile(
      title: RichText(
          text: TextSpan(
        text: "",
        style: const TextStyle(fontSize: 40, color: ColorResources.grey1Color),
        children: <TextSpan>[
          TextSpan(text: hours, style: const TextStyle(fontSize: 40)),
          const TextSpan(text: "H  ", style: TextStyle(fontSize: 20)),
          TextSpan(text: minutes, style: const TextStyle(fontSize: 40)),
          const TextSpan(text: "M  ", style: TextStyle(fontSize: 20)),
          TextSpan(text: seconds, style: const TextStyle(fontSize: 40)),
          const TextSpan(text: "S  ", style: TextStyle(fontSize: 20)),
        ],
      )),
      subtitle: CustomText(cityName),
      trailing: IconButton(
          onPressed: onPress,
          icon: Icon(
            (!isPlay) ? Icons.play_arrow_outlined : Icons.pause,
            color: ColorResources.lav2Color,
            size: 40,
          )),
    );
  }

  Future popup() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timerTextFormFiled(hrsController, "H", Validator.hrsValidate),
                timerTextFormFiled(minController, "M", Validator.minValidate),
                timerTextFormFiled(secController, "S", Validator.minValidate),
              ],
            ),
            actionsPadding: const EdgeInsets.only(bottom: 15),
            actions: [
              CustomText(
                "Cancel",
                style: const TextStyle(
                    color: ColorResources.lav2Color, fontSize: 18),
                onTap: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
              CustomText(
                "Ok",
                style: const TextStyle(
                    color: ColorResources.lav2Color, fontSize: 18),
                onTap: () {
                  setState(() {
                    if (hrsController.text != "" ||
                        minController.text != "" ||
                        secController.text != "") {
                      timesList.add(TimerModule(
                        hrs: hrsController.text.isNotEmpty
                            ? hrsController.text
                            : "00",
                        min: minController.text.isNotEmpty
                            ? minController.text
                            : "00",
                        sec: secController.text.isNotEmpty
                            ? secController.text
                            : "00",
                      ));
                    }
                  });
                  Navigator.pop(context, 'ok');
                },
              )
            ],
          );
        });
  }

  Widget timerTextFormFiled(
      TextEditingController controller, String value, String vPattern) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.allow(RegExp(vPattern))
            ],
            style:
                const TextStyle(fontSize: 40, color: ColorResources.grey1Color),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            decoration:
                const InputDecoration(hintText: '00', border: InputBorder.none),
          ),
        ),
        CustomText(value,
            style: const TextStyle(
                fontSize: 20, color: ColorResources.grey1Color)),
        // const SizedBox(width: 20)
      ],
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }

  void setCountDown() {
    final reduceBy = 1;
    print(myDuration!.inSeconds);
    setState(() {
      final sec = myDuration!.inSeconds - reduceBy;
      print(myDuration!.inSeconds);
      print(sec);
      if (sec < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: sec);
        print(myDuration!.inSeconds);
      }
    });
  }
}
