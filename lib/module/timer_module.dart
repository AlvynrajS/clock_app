import 'package:intl/intl.dart';

class TimerModule {
  String hrs;
  String min;
  String sec;
  bool isPlaying = false;
  String cityName =  DateFormat("EEE " "dd MMM").format(DateTime.now()).toString();

  TimerModule({required this.hrs, required this.min, required this.sec});
}
