import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:stduent_app/models/taskModel.dart';

import 'dart:io' show File, Platform;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:stduent_app/screens/test.dart';
import 'package:stduent_app/services.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<NotificationBody> didReceivedLocalNotificationSubject =
      BehaviorSubject<NotificationBody>();
  var initialzationSettings;

  LocalNotification._() {
    init();
  }
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      iosPermission();
    }
    initialization();
  }

  //initialization all settings to android and ios
  initialization() {
    var initializationAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        NotificationBody notificationBody = NotificationBody(
          name: title,
          id: id,
          body: body,
          payload: payload,
        );
        didReceivedLocalNotificationSubject.add(notificationBody);
      },
    );
    initialzationSettings = InitializationSettings(
      android: initializationAndroid,
      iOS: initializationIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initialzationSettings,
      onSelectNotification: (var payload) async {
        // print(payload);
        if (payload.isNotEmpty) {
          Service.pushtoNotification(payload);
        } else {}
      },
    );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  // onNoitificationClick() async {
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initialzationSettings,
  //     onSelectNotification: (String payload) async {
  //       print("noti has selected");
  //       Navigator.pushNamed(navigation.currentContext, Test.routename);
  //     },
  //   );
  // }

  Future<void> showNotification({
    @required TaskModel taskModel,
  }) async {
    var androidDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosdetails = IOSNotificationDetails();
    var mainDetiles = NotificationDetails(
      android: androidDetails,
      iOS: iosdetails,
    );

    tz.TZDateTime schedule = tz.TZDateTime.parse(
      tz.local,
      taskModel.deadline,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskModel.notiId,
      taskModel.name,
      taskModel.description,
      schedule,
      mainDetiles,
      payload: taskModel.name,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  iosPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: false, badge: false, sound: true);
  }
}

LocalNotification localNotification = LocalNotification._();

class NotificationBody {
  final int id;
  final String name;
  final String body;
  final String payload;
  NotificationBody({
    @required this.name,
    @required this.id,
    @required this.body,
    @required this.payload,
  });
}
