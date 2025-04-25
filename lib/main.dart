import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_model/Dummy_notification.dart';
import 'package:flutter_application_1/view_model/controller_1.dart';
import 'package:flutter_application_1/view_model/homepage_controller.dart';
import 'package:flutter_application_1/view_model/notification_controller.dart';
import 'package:flutter_application_1/view/bottom_navigation/bottom_navigation.dart';
import 'package:flutter_application_1/view/splash_screen/splash_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

String? timeZoneName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HomepageController.initialize();

  // final notificationService = NotificationController();
  // await notificationService.init();
  // final notificationService = DummyController();
  // timeZoneName = await FlutterTimezone.getLocalTimezone();
  // await notificationService.init();

  final notifcationcontriollere = NotificationService();
  await notifcationcontriollere.initNotification();

  runApp(ToDoList());
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    requestPermissions();
    super.initState();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.scheduleExactAlarm,
    ].request();

    if (statuses[Permission.notification]!.isGranted &&
        statuses[Permission.scheduleExactAlarm]!.isGranted) {
      log("All permissions granted");
    } else {
      log("Permissions not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomepageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DummyController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
