import 'dart:async';

import 'package:clock_app/module/timer_module.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/validation.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerScreenDuplicate extends StatefulWidget {
  const TimerScreenDuplicate({Key? key}) : super(key: key);

  @override
  State<TimerScreenDuplicate> createState() => _TimerScreenDuplicateState();
}

class _TimerScreenDuplicateState extends State<TimerScreenDuplicate> {
  TextEditingController hrsController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<TimerModule> timesList = [];
  Timer? countdownTimer;
  Duration? duration;

  String hrStrDigits(int n) => n.toString().padLeft(2, '0');

  String minStrDigits(int n) => n.toString().padLeft(2, '0');

  String secStrDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Recent items",
            style:
                const TextStyle(color: ColorResources.grey1Color, fontSize: 20),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.separated(
                  itemCount: timesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    duration = Duration(
                        hours: int.parse(timesList[index].hrs),
                        minutes: int.parse(timesList[index].min),
                        seconds: int.parse(timesList[index].sec));

                    return ListTile(
                      title: RichText(
                          text: TextSpan(
                        text: "",
                        style: const TextStyle(
                            fontSize: 40, color: ColorResources.grey1Color),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  hrStrDigits(duration!.inHours.remainder(24)),
                              style: const TextStyle(fontSize: 40)),
                          const TextSpan(
                              text: "H  ", style: TextStyle(fontSize: 20)),
                          TextSpan(
                              text: hrStrDigits(
                                  duration!.inMinutes.remainder(24)),
                              style: const TextStyle(fontSize: 40)),
                          const TextSpan(
                              text: "M  ", style: TextStyle(fontSize: 20)),
                          TextSpan(
                              text: hrStrDigits(
                                  duration!.inSeconds.remainder(24)),
                              style: const TextStyle(fontSize: 40)),
                          const TextSpan(
                              text: "S  ", style: TextStyle(fontSize: 20)),
                        ],
                      )),
                      subtitle: CustomText(timesList[index].cityName),
                      trailing: IconButton(
                          onPressed: () {
                            duration;
                            (timesList[index].isPlaying == false)
                                ? startTimer(duration!)
                                : stopTimer();
                            setState(() {
                              timesList[index].isPlaying =
                                  !timesList[index].isPlaying;
                            });
                          },
                          icon: Icon(
                            (!timesList[index].isPlaying)
                                ? Icons.play_arrow_outlined
                                : Icons.pause,
                            color: ColorResources.lav2Color,
                            size: 40,
                          )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      thickness: 1,
                      color: ColorResources.grey1Color,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width / 2.5,
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
              )
            ],
          )
        ],
      ),
    ));
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

  void startTimer(Duration duration) {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setCountDown(tick: timer.tick, duration: duration);
    });
  }

  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }

  void setCountDown({required tick, required duration}) {
    setState(() {
      final sec = duration!.inSeconds - tick;
      print(" sec Duration : ${sec}");
      if (sec < 0) {
        countdownTimer!.cancel();
      } else {
        duration = Duration(seconds: sec.toInt());
      }
    });
  }
}
