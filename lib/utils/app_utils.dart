//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
//
// class AppUtils {
//   Timer? countdownTimer;
//   Duration myDuration = const Duration(days: 5);
//
//   String hrStrDigits(int n) => n.toString().padLeft(1, '0');
//   String minStrDigits(int n) => n.toString().padLeft(2, '0');
//   String secStrDigits(int n) => n.toString().padLeft(2, '0');
//
//   void startTimer() {
//     countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
//   }
//
//   void stopTimer() {
//     setState(() => countdownTimer?.cancel());
//   }
//
//   void resetTimer() {
//     stopTimer();
//     setState(() => myDuration = Duration(days: 5));
//   }
//
//
//   void setCountDown() {
//     final increseSecondsBy = 1;
//     setState(() {
//       final seconds = myDuration.inSeconds + increseSecondsBy;
//       if (seconds < 0) {
//         countdownTimer!.cancel();
//       } else {
//         myDuration = Duration(seconds: seconds);
//       }
//     });
//   }
// }