import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/screens/alarm_screen/alarm_screen.dart';
import 'package:clock_app/screens/clock_screen/clock_screen.dart';
import 'package:clock_app/screens/stopwatch_screen.dart';
import 'package:clock_app/screens/timer_screen/timer_screen.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/image_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask("2", "SimplePeriodic task",frequency: const Duration(minutes: 1));
  AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var andriod = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var setting = InitializationSettings(android: andriod);
    flip.initialize(setting);
    showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future showNotificationWithDefaultSound(flip) async {
  var androidSpecificChannel = const AndroidNotificationDetails(
      "Channel Id", "channelName",
      channelDescription: "Alarm Notification",
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority);
  var platformChannelSpecific =
      NotificationDetails(android: androidSpecificChannel);
  await flip.show(0, "Alarm Notification", "Click me", platformChannelSpecific,
      payload: 'Default_sound');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController? tabBarController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabBarController = TabController(length: 4, vsync: this);
    tabBarController!.addListener(() {
      setState(() {
        selectedIndex == tabBarController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Scaffold(
            bottomSheet: SizedBox(
              height: 100,
              child: Center(
                child: TabBar(
                  controller: tabBarController,
                  indicatorColor: ColorResources.whiteColor,
                  labelColor: ColorResources.grey1Color,
                  tabs: [
                    Tab(
                      height: 100,
                      iconMargin: EdgeInsets.zero,
                      text: (tabBarController != null &&
                              tabBarController!.index == 0)
                          ? ""
                          : "clock",
                      icon: Image.asset((tabBarController != null &&
                              tabBarController!.index == 0)
                          ? ImageResource.cClock
                          : ImageResource.clock),
                    ),
                    Tab(
                        height: 100,
                        iconMargin: EdgeInsets.zero,
                        text: (tabBarController != null &&
                                tabBarController!.index == 1)
                            ? ""
                            : "Alarm",
                        icon: Image.asset((tabBarController != null &&
                                tabBarController!.index == 1)
                            ? ImageResource.cAlarm
                            : ImageResource.alarm)),
                    Tab(
                        height: 100,
                        iconMargin: EdgeInsets.zero,
                        text: (tabBarController != null &&
                                tabBarController!.index == 2)
                            ? ""
                            : "Timer",
                        icon: Image.asset((tabBarController != null &&
                                tabBarController!.index == 2)
                            ? ImageResource.cTimer
                            : ImageResource.timer)),
                    Tab(
                        height: 100,
                        iconMargin: EdgeInsets.zero,
                        text: (tabBarController != null &&
                                tabBarController!.index == 3)
                            ? ""
                            : "Stopwatch",
                        icon: Image.asset((tabBarController != null &&
                                tabBarController!.index == 3)
                            ? ImageResource.cStopWatch
                            : ImageResource.stopWatch))
                  ],
                ),
              ),
            ),
            body: TabBarView(controller: tabBarController, children: const [
              ClockScreen(),
              AlarmScreen(),
              TimerScreen(),
              StopWatchScreen()
            ]),
          )),
    );
  }
}
