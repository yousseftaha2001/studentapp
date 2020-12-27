import 'package:flutter/material.dart';
import 'package:stduent_app/providers/localNotifications.dart';
class TaskView extends StatefulWidget {
  static const routeName="taskView";

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
      ),
    );
  }
}
