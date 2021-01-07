import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stduent_app/widgets/dialog.dart';
import 'dart:core';

import 'providers/databaseProvider.dart';

class Service {
  static GlobalKey navigation = GlobalKey<NavigatorState>();

  static BuildContext context = navigation.currentContext;
  static void NotificationAction(String payload) async{
    print(payload);
     context.read<DataBase>().getAllTask();
    showDialog(
      context: navigation.currentContext,
      builder: (context) => CustomDialog(
        title: payload,
        description: "The task should be ended :)",
      ),
    );
  }
}
