import 'dart:convert';

import 'package:clock_app/module/world_time_model.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart' as http;

class CustomSearchDelegate extends SearchDelegate<City> {
  // Demo list to show querying
  List<City> cities = [
    City('London', 'Europe/London', "6.38 ", "am"),
    City('New York', 'America/New_York', "1.38", "am"),
    City('Los Angeles', 'America/Los_Angeles', "10.38", "pm"),
    City('Sydney', 'Australia/Sydney', "",""),
    City('Tokyo', 'Asia/Tokyo', "",""),
    City('Beijing', 'Asia/Shanghai', "",""),
    City('Mumbai', 'Asia/Kolkata', "",""),
    City('Moscow', 'Europe/Moscow', "",""),
    City('Dubai', 'Asia/Dubai', "",""),
    City('Cape Town', 'Africa/Johannesburg', "",""),
    City('Rio de Janeiro', 'America/Sao_Paulo', "",""),
    City('Buenos Aires', 'America/Argentina/Buenos_Aires', "",""),
    City('Santiago', 'America/Santiago', "",""),
    City('Vancouver', 'America/Vancouver', "",""),
    City('Toronto', 'America/Toronto', "",""),
  ];
  late String location;
  late String time;
  late String timezone;

  getTime() {
    WorldTime(location: '', url: '', flag: '');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, City("name", "timeZone", "",""));
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<City> matchQuery = [];
    for (var name in cities) {
      if (name.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(City(name.name, name.timeZone, name.time,name.range));
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),

          trailing: Row(children:[ Text(result.time), Text(result.range)]),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<City> matchQuery = [];
    for (var cityName in cities) {
      if (cityName.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(City(cityName.name, cityName.timeZone, cityName.time,cityName.range));
      }
    }
    return Container(
      decoration: const BoxDecoration(
          color: ColorResources.grey3Color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      margin: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result.name),
            // trailing: Text(result != null ? result.time : ""),
            onTap: () {
              query = result.name;
              showResults(context);
              close(context, result);
            },
            // trailing: Text(),
          );
        },
      ),
    );
  }

  String _formatDateTime(City city) {
    tz1.TZDateTime now = tz1.TZDateTime.now(tz1.getLocation(city.time));
    String formattedDate =
        DateFormat.jm().format(now.toLocal()); // format the date
    return formattedDate;
  }
}

class City {
  String name;
  String timeZone;
  String time;
  String range;

  City(this.name, this.timeZone, this.time,this.range);

  Future<void> getTime() async {
    try {
      // Make the HTTP request
      http.Response response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$timeZone'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error: $e');
      time = 'Could not get time data';
    }
  }
}
