import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DummyController with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {},
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {},
    );
  }

  // Rest of your methods remain the same...
  tz.TZDateTime convertDateTime(String date, String time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final DateTime parsedDate = DateTime.parse(date);
    final List<String> timeParts = time.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, parsedDate.year,
        parsedDate.month, parsedDate.day, hour, minute);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    log('Converted date-time: $scheduleDate');
    return scheduleDate;
  }

  Future<void> scheduleNotification(int id, String title, String body,
      String scheduledDate, String scheduledTime) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    log('Scheduling notification: title--- $title, body--- $body, date--- $scheduledDate, time--- $scheduledTime');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      id,
      title,
      body,
      tz.TZDateTime.from(
              convertDateTime(scheduledDate, scheduledTime), tz.local)
          .add(const Duration(minutes: 1)),
      const NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(),
      ),
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
    log("Notification scheduled");
  }

  zonedScheduleAlarmClockNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'scheduled alarm clock title',
      'scheduled alarm clock body',
      NotificationDetails(android: androidNotificationDetails),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      // const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //         'alarm_clock_channel', 'Alarm Clock Channel',
      //         channelDescription: 'Alarm Clock Notification')),
      // androidScheduleMode: AndroidScheduleMode.alarmClock,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime
    );

    log("compeleted");
  }

  zonedScheduleAlarmClockNotification2() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        123,
        'scheduled alarm clock title',
        'scheduled alarm clock body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(android: androidNotificationDetails),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    log("finished");
    log("tz time:${tz.TZDateTime.now(tz.local)}");
  }

// --------------------------final-------------------

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }

  Future<void> szonedScheduleAlarmClockNotification() async {
    debugPrint("fhd");
    try {
      var data = await flutterLocalNotificationsPlugin.zonedSchedule(
          123,
          'scheduled alarm clock title',
          'scheduled alarm clock body',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'alarm_clock_channel', 'Alarm Clock Channel',
                  channelDescription: 'Alarm Clock Notification')),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future scheduleNotification_final({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    log("schedule date time--- $scheduledNotificationDateTime");
    log("tz local--- ${tz.TimeZone}");
    return flutterLocalNotificationsPlugin.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        // androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
