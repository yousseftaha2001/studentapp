import 'package:flutter/material.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/localNotifications.dart';
import 'dart:math'as math;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../services.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  GlobalKey key = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: RaisedButton(
        onPressed: () async {
          await setNotification();
          Navigator.of(context).pop();
        },
        child: Text("navi"),
      ),
    );
  }

  setNotification() async {
    tz.TZDateTime shuadle = tz.TZDateTime.parse(
      tz.local,
      DateTime.now().add(Duration(minutes: 2)).toString(),
    );
    int id=DateTime.now().microsecondsSinceEpoch;
    while(id>math.pow(2, 32)){
      id=id~/math.pow(2, 10);
    }
    await localNotification.showNotification(
      taskModel: TaskModel(
        name: "go to gym",
        description: "go to gym after school",
        id: "kmefkjf;dsm;f",
        notiId: id,
        //مشكلة ال bits
        deadline: DateTime.now().add(Duration(minutes: 1)).toString(),
        createdTime: DateTime.now().toString(),
      ),
    );
    // await localNotification.showNotification(
    //   id: 0,
    //   title: "youssef",
    //   body: "it is done",
    //   scheduleTime: shuadle,
    // );
  }
}
