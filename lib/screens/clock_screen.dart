import 'dart:convert';

import 'package:clock_app/screens/search_screen.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz1;

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen>
    with AutomaticKeepAliveClientMixin {
  var hhmm = DateFormat("HH:mm").format(DateTime.now());
  var range = DateFormat("a").format(DateTime.now());
  var weekday = DateFormat("EEE").format(DateTime.now());
  var date = DateFormat("dd MMM").format(DateTime.now());
  var selectedCity;
  String datetime = '';
  String timezone = '';

  TextEditingController cityController = TextEditingController();

  List worldClockList = [];

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future<void> getTime(timeZone) async {
    try {
      // Make the HTTP request
      http.Response response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$timeZone'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      datetime =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error: $e');
      datetime = 'Could not get time data';
    }
  }

  @override
  void initState() {
    worldClockList;
    tz1.initializeTimeZones();
    super.initState();
  }

  String formatDateTime(City city) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(city.timeZone));
    String formattedDate =
        DateFormat("HH:mm").format(now.toLocal()); // format the date
    return formattedDate;
  }

  String formatTimeZone(City city) {
    var d =getTime(city.timeZone);
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(city.timeZone));
    String formattedDate = DateFormat("aa").format(now); // format the date
    return formattedDate;
  }

  String differenceTime(City city) {
    tz.TZDateTime one = tz.TZDateTime.now(tz.getLocation(city.timeZone));
    String formattedDate = DateFormat("HH:mm").format(one.toLocal());
    String two = hhmm;
    var diff = int.parse(formattedDate) - int.parse(hhmm);
    String result = "2 hrs 30 min";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(hhmm,
                  style: const TextStyle(
                      fontSize: 60, color: ColorResources.lav2Color)),
              const SizedBox(width: 20),
              CustomText(range,
                  style: const TextStyle(
                      fontSize: 40, color: ColorResources.lav2Color)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("${weekday} , ${date}",
                  style: const TextStyle(
                      fontSize: 20, color: ColorResources.lav2Color)),
              const SizedBox(width: 30),
              CustomText("Chennai",
                  style: const TextStyle(
                      fontSize: 15, color: ColorResources.lav2Color)),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 10, color: ColorResources.grey1Color),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.separated(
                    itemBuilder: (context, ints) {
                      return listTile(
                          worldClockList[ints].name,
                          "5 hr 03 min",
                          worldClockList[ints].time,
                          worldClockList[ints].range);
                    },
                    separatorBuilder: (context, ints) {
                      return const Divider(
                          height: 10, color: ColorResources.grey1Color);
                    },
                    itemCount: worldClockList.length),
              ),
              Positioned(
                bottom: 55,
                left: MediaQuery.of(context).size.width / 2.3,
                right: MediaQuery.of(context).size.width / 2.4,
                child: FloatingActionButton(
                  onPressed: () async {
                    selectedCity = await showSearch(
                        context: context, delegate: CustomSearchDelegate());

                    // selectedCity =   await showSearch(
                    // context: context, delegate: CustomSearchDelegate2());
                    setState(() {
                      selectedCity;
                      print("selectedCity : $selectedCity");
                      worldClockList.addAll([selectedCity]);
                    });
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
        ],
      ),
    );
  }

  Widget listTile(
      String cityName, String hrsDetail, String time, String timeRange) {
    return ListTile(
      title: CustomText(cityName, style: const TextStyle(fontSize: 20)),
      subtitle: CustomText(hrsDetail, style: const TextStyle(fontSize: 20)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(time,
              style: const TextStyle(
                  fontSize: 40, color: ColorResources.grey1Color)),
          const SizedBox(width: 10),
          CustomText(timeRange, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
