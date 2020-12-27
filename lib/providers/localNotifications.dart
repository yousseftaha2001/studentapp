import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:stduent_app/main.dart';
import 'package:stduent_app/screens/addTask.dart';
import 'dart:io' show File, Platform;

import 'package:stduent_app/screens/taskView.dart';

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
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  onNoitificationClick(Function click) async {
    await flutterLocalNotificationsPlugin.initialize(
      initialzationSettings,
      onSelectNotification: (String payload) async {
       await click;
       //add
      },
    );
  }

  Future<void> showNotification({
    @required int id,
    @required String title,
    @required String body,
    @required DateTime scheduleTime,
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
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      mainDetiles,
      payload: "Test",
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
