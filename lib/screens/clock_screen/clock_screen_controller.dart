import 'dart:convert';

import 'package:clock_app/widgets/custom_list_tile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ClockScreenController extends GetxController with StateMixin {
  RxString cityName = ''.obs;
  RxBool isDaytime = false.obs;
  RxString time = ''.obs;
  RxString selectedCityName = "".obs;
  RxList cities = [].obs;
  RxString diff = ''.obs;

  Future<void> getCurrentCity() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      change(cityName.value = placemark.locality ?? '');
    } else {
      await Permission.location.request();
      await getCurrentCity();
    }
  }

  Future<void> getTime() async {
    try {
      // Make the API call to get the current time for this location
      var response = await get(
          Uri.parse('http://worldtimeapi.org/api/timezone/$selectedCityName'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      isDaytime.value = now.hour > 6 && now.hour < 20;
      time.value = DateFormat("hh:mm").format(now);
      String time2 = DateFormat("hh:mm a").format(now);
      String range = DateFormat("a").format(now);
      String cName = data['timezone'];
      String cTime = DateFormat("hh:mm a").format(DateTime.now());

      // Date Difference
      DateTime dateTime1 = DateFormat('h:mm a').parse(cTime);
      DateTime dateTime2 = DateFormat('h:mm a').parse(time2);
      Duration difference = dateTime2.difference(dateTime1);

      if (difference.isNegative) {
        diff.value =
            '${difference.inHours} hours ${difference.inMinutes.remainder(60)} minutes behind';
      } else {
        diff.value;
      }
      cities.value.addAll([
        CustomListTile(
          clock: cName,
          subTitle: diff.replaceAll("-", ""),
          atime: time.value,
          timeRange: range,
        )

        // CustomListTile(title:cName,subTitle:diff.replaceAll("-", ""),)
      ]);

      //cName, diff.replaceAll("-", ""), time, range)]);
      change(cities);
    } catch (e) {
      print('Error caught: $e');
      time.value = 'Could not get time data';
    }
  }
}
