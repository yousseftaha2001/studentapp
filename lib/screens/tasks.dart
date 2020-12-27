import 'package:flutter/material.dart';
import 'package:stduent_app/screens/addTask.dart';
import 'package:stduent_app/screens/taskView.dart';

import 'package:stduent_app/providers/localNotifications.dart';
import 'package:stduent_app/widgets/tasklist.dart';





class Tasks extends StatefulWidget{

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return TasksList();
  }
}
