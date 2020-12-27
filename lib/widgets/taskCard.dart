import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/TaskCrdProvider.dart';
import 'package:stduent_app/screens/addTask.dart';

import '../colos,fonts.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  TaskModel taskModel;
  List<String> dele;

  TaskCard({@required this.dele,@required this.taskModel});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Selector<TaskCardProvider, bool>(
      selector: (context, modes) => modes.mode,
      builder: (context, mode, __) {
        return Material(
          elevation: 10,
          child: ListTile(
            onTap: () {
              if (Provider.of<TaskCardProvider>(context, listen: false).mode) {
                Provider.of<TaskCardProvider>(context, listen: false)
                    .changeMode(false);
                widget.dele = [];
              } else {
                Navigator.of(context).push(_createRoute());
              }
            },
            onLongPress: () {
              Provider.of<TaskCardProvider>(context, listen: false)
                  .changeMode(true);
            },
            title: Text(
              widget.taskModel.name,
              style: Ui.main.copyWith(fontSize: 20, color: Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskModel.description.split(" ")[0],
                  style: Ui.main.copyWith(fontSize: 15, color: Colors.black),
                ),
                Text(
                  getDate(),
                  style: Ui.main.copyWith(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
            leading: mode
                ? Checkbox(
                    value: _selected,
                    checkColor: Colors.white,
                    activeColor: Ui.mainColor,
                    onChanged: (bool val) {
                      setState(
                        () {
                          _selected = val;
                          if (val) {
                            widget.dele.add(widget.taskModel.id);
                          } else {
                            widget.dele.remove(widget.taskModel.id);
                          }
                        },
                      );
                    },
                  )
                : Icon(
                    Icons.work,
                    color: Ui.mainColor,
                  ),
            trailing: Container(
              color: Ui.mainColor,
              width: 2,
              height: 30,
            ),
          ),
        );
      },
    );
  }

  String getDate() {
    var d = DateTime.parse(widget.taskModel.deadline);
    String min = d.minute.toString();
    String ho = d.hour.toString();
    return ho + ":" + min;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddNew(
        taskModel: widget.taskModel,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
