import 'dart:async';
import 'package:clock_app/module/timer_module.dart';
import 'package:clock_app/screens/timer_screen_controller.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/validation.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenDuplicate();
}

class _TimerScreenDuplicate extends State<TimerScreen> {
  TimerScreenController controller = Get.put(TimerScreenController());

  String hrStrDigits(int n) => n.toString().padLeft(2, '0');
  String minStrDigits(int n) => n.toString().padLeft(2, '0');
  String secStrDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    // timesList;
    // durationList;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimerScreenController>(
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Recent items",
                style: const TextStyle(
                    color: ColorResources.grey1Color, fontSize: 20),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Obx(() {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.separated(
                        itemCount: controller.timesList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          TimerModule _module =
                              controller.timesList.value[index];
                          return ListTile(
                            title: _printDuration(
                                controller.durationList.value[index]),
                            subtitle: CustomText(_module.cityName),
                            trailing: IconButton(
                                onPressed: () {
                                  (_module.isPlaying == false)
                                      ? startTimer(index)
                                      : stopTimer(index);
                                  setState(() {
                                    _module.isPlaying = !_module.isPlaying;
                                  });
                                },
                                icon: Icon(
                                  (!_module.isPlaying)
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
                    );
                  }),
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
      },
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
                timerTextFormFiled(
                    controller.hrsController, "H", Validator.hrsValidate),
                timerTextFormFiled(
                    controller.minController, "M", Validator.minValidate),
                timerTextFormFiled(
                    controller.secController, "S", Validator.minValidate),
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
                    int _hour = 0;
                    int _minute = 0;
                    int _second = 0;

                    if (controller.hrsController.text.isNotEmpty) {
                      _hour = int.parse(controller.hrsController.text);
                    }
                    if (controller.minController.text.isNotEmpty) {
                      _minute = int.parse(controller.minController.text);
                    }
                    if (controller.secController.text.isNotEmpty) {
                      _second = int.parse(controller.secController.text);
                    }

                    if (controller.hrsController.text != "" ||
                        controller.minController.text != "" ||
                        controller.secController.text != "") {
                      controller.timesList.add(TimerModule(
                        hrs: controller.hrsController.text.isNotEmpty
                            ? controller.hrsController.text
                            : "00",
                        min: controller.minController.text.isNotEmpty
                            ? controller.minController.text
                            : "00",
                        sec: controller.secController.text.isNotEmpty
                            ? controller.secController.text
                            : "00",
                      ));
                      controller.durationList.value.add(Duration(
                          hours: _hour, minutes: _minute, seconds: _second));

                      controller.countdownTimerList.value
                          .add(Timer(Duration(seconds: 1), () {}));
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

  void startTimer(int index) {
    if (controller.countdownTimerList.value.isNotEmpty) {
      controller.countdownTimerList.value[index].cancel();
    }
    controller.countdownTimerList.value[index] =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      setCountDown(
          durations: controller.durationList.value[index], index: index);
    });
  }

  void stopTimer(int index) {
    setState(() => controller.countdownTimerList.value[index].cancel());
  }

  void setCountDown({required Duration durations, required index}) {
    final sec = durations!.inSeconds - 1;
    if (sec < 0) {
      controller.countdownTimerList.value[index].cancel();
    } else {
      durations = Duration(seconds: sec.toInt());
      controller.durationList.value[index] = durations;
      print(controller.durationList.value[index]);
      controller.update();
    }
  }

  RichText _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return RichText(
        text: TextSpan(
      text: "",
      style: const TextStyle(fontSize: 40, color: ColorResources.grey1Color),
      children: <TextSpan>[
        TextSpan(
            text: twoDigits(duration.inHours),
            style: const TextStyle(fontSize: 40)),
        const TextSpan(text: "H  ", style: TextStyle(fontSize: 20)),
        TextSpan(text: twoDigitMinutes, style: const TextStyle(fontSize: 40)),
        const TextSpan(text: "M  ", style: TextStyle(fontSize: 20)),
        TextSpan(text: twoDigitSeconds, style: const TextStyle(fontSize: 40)),
        const TextSpan(text: "S  ", style: TextStyle(fontSize: 20)),
      ],
    ));
  }
}
