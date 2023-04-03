import 'dart:convert';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenSecondState();
}

class _ClockScreenSecondState extends State<ClockScreen> {
  String cityName = '';
  bool isDaytime = false;
  String time = '';
  String selectedCityName = "";
  List cities = [];
  String diff = '';

  Future<void> getCurrentCity() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      setState(() {
        cityName = placemark.locality ?? '';
      });
    } else {
      await Permission.location.request();
      await getCurrentCity();
    }
  }

  Future<void> getTime() async {
    try {
      // Make the API call to get the current time for this location
      Response response = await get(
          Uri.parse('http://worldtimeapi.org/api/timezone/$selectedCityName'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      isDaytime = now.hour > 6 && now.hour < 20;
      time = DateFormat("hh:mm").format(now);
      String time2 = DateFormat("hh:mm a").format(now);
      String range = DateFormat("a").format(now);
      String cName = data['timezone'];
      String cTime = DateFormat("hh:mm a").format(DateTime.now());
      // Date Difference
      DateTime dateTime1 = DateFormat('h:mm a').parse(cTime);
      DateTime dateTime2 = DateFormat('h:mm a').parse(time2);
      Duration difference = dateTime2.difference(dateTime1);
      if (difference.isNegative) {
        diff =
            '${difference.inHours} hours ${difference.inMinutes.remainder(60)} minutes behind';
        // print("diff is :$diff");
      } else {
        diff;
      }

      cities.addAll([listTile(cName, diff.replaceAll("-", ""), time, range)]);
      setState(() {
        cities;
      });
    } catch (e) {
      print('Error caught: $e');
      time = 'Could not get time data';
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentCity();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(height: MediaQuery.of(context).size.height / 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                DateFormat("hh:mm").format(DateTime.now()),
                style: const TextStyle(
                    color: ColorResources.lav2Color,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              CustomText(
                DateFormat("a").format(DateTime.now()),
                style: const TextStyle(
                    color: ColorResources.lav2Color,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                DateFormat("EEE , dd MMM").format(DateTime.now()),
                style: const TextStyle(
                    color: ColorResources.lav2Color,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 10),
              CustomText(cityName,
                  style: const TextStyle(
                      color: ColorResources.lav2Color,
                      fontSize: 18,
                      fontWeight: FontWeight.w400))
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 10,
            color: ColorResources.grey1Color,
          ),
          Stack(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return cities[index];
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                      height: 10, color: ColorResources.grey1Color);
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 120),
            //   child:
            Positioned(
              top: MediaQuery.of(context).size.height / 2.5,
              right: MediaQuery.of(context).size.width / 2.3,
              left: MediaQuery.of(context).size.width / 2.4,
              child: FloatingActionButton(
                backgroundColor: ColorResources.lav2Color,
                onPressed: () async {
                  selectedCityName =
                      await showSearch(context: context, delegate: SearchBar());
                  print("selectedCityName before : $selectedCityName");
                  setState(() {
                    selectedCityName;
                    print("selectedCityName before : $selectedCityName");
                    getTime();
                  });
                },
                splashColor: ColorResources.lav2Color,
                child: const Icon(Icons.add),
              ),
            ),
            // )
          ]),
        ]),
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
}

class SearchBar extends SearchDelegate {
  List<String> cityList = [
    "Africa/Abidjan",
    "Africa/Accra",
    "Africa/Algiers",
    "Africa/Bissau",
    "Africa/Cairo",
    "Africa/Casablanca",
    "Africa/Ceuta",
    "Africa/El_Aaiun",
    "Africa/Johannesburg",
    "Africa/Juba",
    "Africa/Khartoum",
    "Africa/Lagos",
    "Africa/Maputo",
    "Africa/Monrovia",
    "Africa/Nairobi",
    "Africa/Ndjamena",
    "Africa/Sao_Tome",
    "Africa/Tripoli",
    "Africa/Tunis",
    "Africa/Windhoek",
    "America/Adak",
    "America/Anchorage",
    "America/Araguaina",
    "America/Argentina/Buenos_Aires",
    "America/Argentina/Catamarca",
    "America/Argentina/Cordoba",
    "America/Argentina/Jujuy",
    "America/Argentina/La_Rioja",
    "America/Argentina/Mendoza",
    "America/Argentina/Rio_Gallegos",
    "America/Argentina/Salta",
    "America/Argentina/San_Juan",
    "America/Argentina/San_Luis",
    "America/Argentina/Tucuman",
    "America/Argentina/Ushuaia",
    "America/Asuncion",
    "America/Atikokan",
    "America/Bahia",
    "America/Bahia_Banderas",
    "America/Barbados",
    "America/Belem",
    "America/Belize",
    "America/Blanc-Sablon",
    "America/Boa_Vista",
    "America/Bogota",
    "America/Boise",
    "America/Cambridge_Bay",
    "America/Campo_Grande",
    "America/Cancun",
    "America/Caracas",
    "America/Cayenne",
    "America/Chicago",
    "America/Chihuahua",
    "America/Costa_Rica",
    "America/Creston",
    "America/Cuiaba",
    "America/Curacao",
    "America/Danmarkshavn",
    "America/Dawson",
    "America/Dawson_Creek",
    "America/Denver",
    "America/Detroit",
    "America/Edmonton",
    "America/Eirunepe",
    "America/El_Salvador",
    "America/Fort_Nelson",
    "America/Fortaleza",
    "America/Glace_Bay",
    "America/Goose_Bay",
    "America/Grand_Turk",
    "America/Guatemala",
    "America/Guayaquil",
    "America/Guyana",
    "America/Halifax",
    "America/Havana",
    "America/Hermosillo",
    "America/Indiana/Indianapolis",
    "America/Indiana/Knox",
    "America/Indiana/Marengo",
    "America/Indiana/Petersburg",
    "America/Indiana/Tell_City",
    "America/Indiana/Vevay",
    "America/Indiana/Vincennes",
    "America/Indiana/Winamac",
    "America/Inuvik",
    "America/Iqaluit",
    "America/Jamaica",
    "America/Juneau",
    "America/Kentucky/Louisville",
    "America/Kentucky/Monticello",
    "America/La_Paz",
    "America/Lima",
    "America/Los_Angeles",
    "America/Maceio",
    "America/Managua",
    "America/Manaus",
    "America/Martinique",
    "America/Matamoros",
    "America/Mazatlan",
    "America/Menominee",
    "America/Merida",
    "America/Metlakatla",
    "America/Mexico_City",
    "America/Miquelon",
    "America/Moncton",
    "America/Monterrey",
    "America/Montevideo",
    "America/Nassau",
    "America/New_York",
    "America/Nipigon",
    "America/Nome",
    "America/Noronha",
    "America/North_Dakota/Beulah",
    "America/North_Dakota/Center",
    "America/North_Dakota/New_Salem",
    "America/Nuuk",
    "America/Ojinaga",
    "America/Panama",
    "America/Pangnirtung",
    "America/Paramaribo",
    "America/Phoenix",
    "America/Port-au-Prince",
    "America/Port_of_Spain",
    "America/Porto_Velho",
    "America/Puerto_Rico",
    "America/Punta_Arenas",
    "America/Rainy_River",
    "America/Rankin_Inlet",
    "America/Recife",
    "America/Regina",
    "America/Resolute",
    "America/Rio_Branco",
    "America/Santarem",
    "America/Santiago",
    "America/Santo_Domingo",
    "America/Sao_Paulo",
    "America/Scoresbysund",
    "America/Sitka",
    "America/St_Johns",
    "America/Swift_Current",
    "America/Tegucigalpa",
    "America/Thule",
    "America/Thunder_Bay",
    "America/Tijuana",
    "America/Toronto",
    "America/Vancouver",
    "America/Whitehorse",
    "America/Winnipeg",
    "America/Yakutat",
    "America/Yellowknife",
    "Antarctica/Casey",
    "Antarctica/Davis",
    "Antarctica/DumontDUrville",
    "Antarctica/Macquarie",
    "Antarctica/Mawson",
    "Antarctica/Palmer",
    "Antarctica/Rothera",
    "Antarctica/Syowa",
    "Antarctica/Troll",
    "Antarctica/Vostok",
    "Asia/Almaty",
    "Asia/Amman",
    "Asia/Anadyr",
    "Asia/Aqtau",
    "Asia/Aqtobe",
    "Asia/Ashgabat",
    "Asia/Atyrau",
    "Asia/Baghdad",
    "Asia/Baku",
    "Asia/Bangkok",
    "Asia/Barnaul",
    "Asia/Beirut",
    "Asia/Bishkek",
    "Asia/Brunei",
    "Asia/Chita",
    "Asia/Choibalsan",
    "Asia/Colombo",
    "Asia/Damascus",
    "Asia/Dhaka",
    "Asia/Dili",
    "Asia/Dubai",
    "Asia/Dushanbe",
    "Asia/Famagusta",
    "Asia/Gaza",
    "Asia/Hebron",
    "Asia/Ho_Chi_Minh",
    "Asia/Hong_Kong",
    "Asia/Hovd",
    "Asia/Irkutsk",
    "Asia/Jakarta",
    "Asia/Jayapura",
    "Asia/Jerusalem",
    "Asia/Kabul",
    "Asia/Kamchatka",
    "Asia/Karachi",
    "Asia/Kathmandu",
    "Asia/Khandyga",
    "Asia/Kolkata",
    "Asia/Krasnoyarsk",
    "Asia/Kuala_Lumpur",
    "Asia/Kuching",
    "Asia/Macau",
    "Asia/Magadan",
    "Asia/Makassar",
    "Asia/Manila",
    "Asia/Nicosia",
    "Asia/Novokuznetsk",
    "Asia/Novosibirsk",
    "Asia/Omsk",
    "Asia/Oral",
    "Asia/Pontianak",
    "Asia/Pyongyang",
    "Asia/Qatar",
    "Asia/Qostanay",
    "Asia/Qyzylorda",
    "Asia/Riyadh",
    "Asia/Sakhalin",
    "Asia/Samarkand",
    "Asia/Seoul",
    "Asia/Shanghai",
    "Asia/Singapore",
    "Asia/Srednekolymsk",
    "Asia/Taipei",
    "Asia/Tashkent",
    "Asia/Tbilisi",
    "Asia/Tehran",
    "Asia/Thimphu",
    "Asia/Tokyo",
    "Asia/Tomsk",
    "Asia/Ulaanbaatar",
    "Asia/Urumqi",
    "Asia/Ust-Nera",
    "Asia/Vladivostok",
    "Asia/Yakutsk",
    "Asia/Yangon",
    "Asia/Yekaterinburg",
    "Asia/Yerevan",
    "Atlantic/Azores",
    "Atlantic/Bermuda",
    "Atlantic/Canary",
    "Atlantic/Cape_Verde",
    "Atlantic/Faroe",
    "Atlantic/Madeira",
    "Atlantic/Reykjavik",
    "Atlantic/South_Georgia",
    "Atlantic/Stanley",
    "Australia/Adelaide",
    "Australia/Brisbane",
    "Australia/Broken_Hill",
    "Australia/Darwin",
    "Australia/Eucla",
    "Australia/Hobart",
    "Australia/Lindeman",
    "Australia/Lord_Howe",
    "Australia/Melbourne",
    "Australia/Perth",
    "Australia/Sydney",
    "CET",
    "CST6CDT",
    "EET",
    "EST",
    "EST5EDT",
    "Etc/GMT",
    "Etc/GMT+1",
    "Etc/GMT+10",
    "Etc/GMT+11",
    "Etc/GMT+12",
    "Etc/GMT+2",
    "Etc/GMT+3",
    "Etc/GMT+4",
    "Etc/GMT+5",
    "Etc/GMT+6",
    "Etc/GMT+7",
    "Etc/GMT+8",
    "Etc/GMT+9",
    "Etc/GMT-1",
    "Etc/GMT-10",
    "Etc/GMT-11",
    "Etc/GMT-12",
    "Etc/GMT-13",
    "Etc/GMT-14",
    "Etc/GMT-2",
    "Etc/GMT-3",
    "Etc/GMT-4",
    "Etc/GMT-5",
    "Etc/GMT-6",
    "Etc/GMT-7",
    "Etc/GMT-8",
    "Etc/GMT-9",
    "Etc/UTC",
    "Europe/Amsterdam",
    "Europe/Andorra",
    "Europe/Astrakhan",
    "Europe/Athens",
    "Europe/Belgrade",
    "Europe/Berlin",
    "Europe/Brussels",
    "Europe/Bucharest",
    "Europe/Budapest",
    "Europe/Chisinau",
    "Europe/Copenhagen",
    "Europe/Dublin",
    "Europe/Gibraltar",
    "Europe/Helsinki",
    "Europe/Istanbul",
    "Europe/Kaliningrad",
    "Europe/Kiev",
    "Europe/Kirov",
    "Europe/Lisbon",
    "Europe/London",
    "Europe/Luxembourg",
    "Europe/Madrid",
    "Europe/Malta",
    "Europe/Minsk",
    "Europe/Monaco",
    "Europe/Moscow",
    "Europe/Oslo",
    "Europe/Paris",
    "Europe/Prague",
    "Europe/Riga",
    "Europe/Rome",
    "Europe/Samara",
    "Europe/Saratov",
    "Europe/Simferopol",
    "Europe/Sofia",
    "Europe/Stockholm",
    "Europe/Tallinn",
    "Europe/Tirane",
    "Europe/Ulyanovsk",
    "Europe/Uzhgorod",
    "Europe/Vienna",
    "Europe/Vilnius",
    "Europe/Volgograd",
    "Europe/Warsaw",
    "Europe/Zaporozhye",
    "Europe/Zurich",
    "HST",
    "Indian/Chagos",
    "Indian/Christmas",
    "Indian/Cocos",
    "Indian/Kerguelen",
    "Indian/Mahe",
    "Indian/Maldives",
    "Indian/Mauritius",
    "Indian/Reunion",
    "MET",
    "MST",
    "MST7MDT",
    "PST8PDT",
    "Pacific/Apia",
    "Pacific/Auckland",
    "Pacific/Bougainville",
    "Pacific/Chatham",
    "Pacific/Chuuk",
    "Pacific/Easter",
    "Pacific/Efate",
    "Pacific/Enderbury",
    "Pacific/Fakaofo",
    "Pacific/Fiji",
    "Pacific/Funafuti",
    "Pacific/Galapagos",
    "Pacific/Gambier",
    "Pacific/Guadalcanal",
    "Pacific/Guam",
    "Pacific/Honolulu",
    "Pacific/Kiritimati",
    "Pacific/Kosrae",
    "Pacific/Kwajalein",
    "Pacific/Majuro",
    "Pacific/Marquesas",
    "Pacific/Nauru",
    "Pacific/Niue",
    "Pacific/Norfolk",
    "Pacific/Noumea",
    "Pacific/Pago_Pago",
    "Pacific/Palau",
    "Pacific/Pitcairn",
    "Pacific/Pohnpei",
    "Pacific/Port_Moresby",
    "Pacific/Rarotonga",
    "Pacific/Tahiti",
    "Pacific/Tarawa",
    "Pacific/Tongatapu",
    "Pacific/Wake",
    "Pacific/Wallis",
    "WET"
  ];

  // Future<List<String>> fetchCityList() async {
  //   final response =
  //       await http.get(Uri.parse('http://worldtimeapi.org/api/timezone'));
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body) as List<dynamic>;
  //     final list = json.map((item) => item['title'] as String).toList();
  //     return list;
  //   } else {
  //     throw Exception('Failed to fetch data');
  //   }
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [Container()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (query == "") {
          close(context, "");
        } else {
          close(context, query);
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(query),
    );

    // ListView.builder(
    //   itemCount: cityList.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(cityList[index]),
    //       subtitle: Text(cityList[index]),
    //       onTap: () {
    //         // Handle tapping on the list item
    //       },
    //     );
    //   });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestion = cityList.where((sList) {
      final result = sList.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Container(
      decoration: const BoxDecoration(
          color: ColorResources.grey3Color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      margin: const EdgeInsets.all(20),
      child: ListView.builder(
          itemCount: suggestion.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(suggestion[index]),
              onTap: () {
                query = suggestion[index];
                // showResults(context);
                close(context, query);
              },
            );
          }),
    );
  }
}

// list get from API
//   FutureBuilder<List<String>>(
//   future: fetchCityList(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasData) {
//         final data = snapshot.data!;
//         return ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(data[index]),
//             );
//           },
//         );
//       } else {
//         return Center(child: Text('No data available'));
//       }
//     } else {
//       return Center(child: CircularProgressIndicator());
//     }
//   },
// );
