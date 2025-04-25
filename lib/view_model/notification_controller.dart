import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // actions: <AndroidNotificationAction>[
      //   AndroidNotificationAction(
      //     "urlLaunchActionId",
      //     'Action 1',
      //     icon: DrawableResourceAndroidBitmap('food'),
      //     contextual: true,
      //   ),
      //   AndroidNotificationAction(
      //     'id_2',
      //     'Action 2',
      //     titleColor: Color.fromARGB(255, 255, 0, 0),
      //     icon: DrawableResourceAndroidBitmap('secondary_icon'),
      //   ),
      //   AndroidNotificationAction(
      //     "navigationActionId",
      //     'Action 3',
      //     icon: DrawableResourceAndroidBitmap('secondary_icon'),
      //     showsUserInterface: true,
      //     // By default, Android plugin will dismiss the notification when the
      //     // user tapped on a action (this mimics the behavior on iOS).
      //     cancelNotification: false,
      //   ),
      // ],
    );

    log('Scheduling notification: $title at $scheduledDate');
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      "s",
      NotificationDetails(
        android: androidNotificationDetails,
      ),
    );
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.from(scheduledDate, tz.local),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'your_channel_id',
    //       'your_channel_name',
    //       channelDescription: 'your_channel_description',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //     ),
    //   ),
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  // new code

  /// Initialize notification
  initializeNotification() async {
    // _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  // Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  //   log("time zone----$timeZone");
  //   tz.setLocalLocation(tz.getLocation(timeZone));
  // }

// sheduled notification
  scheduledNotification1({
    required int hour,
    required int minutes,
    required int id,
    // required String sound,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'It\'s time to drink water!',
      'After drinking, touch the cup to confirm',
      _convertTime(hour, minutes),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound(sound),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'It could be anything you pass',
    );
  }

  cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}
