import 'package:clock_app/screens/alarm_screen.dart';
import 'package:clock_app/screens/clock_screen.dart';
import 'package:clock_app/screens/stopwatch_screen.dart';
import 'package:clock_app/screens/timer_screen.dart';
import 'package:clock_app/utils/color_resources.dart';
import 'package:clock_app/utils/image_resource.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
