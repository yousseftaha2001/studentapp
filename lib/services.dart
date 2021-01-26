import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/widgets/dialog.dart';
import 'dart:core';
import 'providers/databaseProvider.dart';

class MyService {
  static List<TaskModel>unfinishedTasks=[];
  static List<TaskModel>finishedTasks=[];
  static GlobalKey navigation = GlobalKey<NavigatorState>();
  static BuildContext context = navigation.currentContext;
  static DataBase dataBase=Provider.of<DataBase>(context,listen: false);
  static void notificationAction(String payload) async {
    print(payload);
    context.read<DataBase>().getAllTasks();
    showDialog(
      context: navigation.currentContext,
      builder: (context) => CustomDialog(
        mode: false,
        title: payload,
        description: "The task should be ended :)",
        icon: Icon(Icons.home_work),
      ),
    );
  }



}
