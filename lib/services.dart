import 'package:flutter/material.dart';

import 'package:stduent_app/widgets/dialog.dart';
import 'dart:core';

class Service {
  static GlobalKey navigation = GlobalKey<NavigatorState>();

  BuildContext context = navigation.currentContext;
  static void pushtoNotification(String payload) {
    print(payload);
    showDialog(
      context: navigation.currentContext,
      builder: (context) => CustomDialog(
        title: payload,
        description: "The task should be ended :)",
      ),
    );
  }
}
