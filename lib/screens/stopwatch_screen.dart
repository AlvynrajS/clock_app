import 'dart:async';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen>
    with AutomaticKeepAliveClientMixin {
  bool isPlay = false;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);

  String hrStrDigits(int n) => n.toString().padLeft(1, '0');
  String minStrDigits(int n) => n.toString().padLeft(1, '0');
  String secStrDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = hrStrDigits(myDuration.inHours.remainder(24));
    final minutes = minStrDigits(myDuration.inMinutes.remainder(60));
    final seconds = secStrDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: ColorResources.grey1Color,
            radius: 120,
            child: CircleAvatar(
              radius: 118,
              backgroundColor: Colors.white,
              child: RichText(
                  text: TextSpan(
                text: minutes,
                style: const TextStyle(
                    fontSize: 80, color: ColorResources.grey1Color),
                children: <TextSpan>[
                  TextSpan(
                      text: seconds, style: const TextStyle(fontSize: 40)),
                ],
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                    visible: isPlay,
                    child: CustomText(
                      "Reset",
                      onTap: () {
                        resetTimer();
                        setState(() {
                          isPlay = !isPlay;
                        });
                      },
                    )),
                FloatingActionButton(
                  onPressed: () {
                    (!isPlay) ? startTimer() : stopTimer();
                    setState(() {
                      isPlay = !isPlay;
                    });
                  },
                  backgroundColor: ColorResources.lav2Color,
                  child: Center(
                      child: Icon(
                        (!isPlay) ? Icons.play_arrow_outlined : Icons.pause,
                        size: 35,
                      )),
                ),
                Visibility(
                    visible: isPlay,
                    child: CustomText(
                      "Exit",
                      onTap: () {
                        resetTimer();
                        setState(() {
                          isPlay = !isPlay;
                        });
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }

  void setCountDown() {
    final increseSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds + increseSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
