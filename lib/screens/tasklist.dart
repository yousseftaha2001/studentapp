import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/TaskCrdProvider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/providers/localNotifications.dart';
import 'package:stduent_app/screens/addTask.dart';
import 'package:stduent_app/widgets/taskCard.dart';
import 'package:stduent_app/widgets/tasksFuture.dart';

import '../colos,fonts.dart';
import '../main.dart';

class TasksList extends StatelessWidget {
  List<TaskModel> deletedTasks = [];

  bool mode = true;

  @override
  Widget build(BuildContext context) {
    print("screen built");
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Tasks"),
          centerTitle: true,
          backgroundColor: Ui.mainColor,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Unfinished business",
                  style: Ui.main.copyWith(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "finished business",
                  style: Ui.main.copyWith(fontSize: 17),
                ),
              ),
            ],
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Ui.secColor,
            unselectedLabelColor: Colors.grey,
            onTap: (int index) {
              index == 0 ? mode = true : mode = false;
              print(mode);
            },
          ),
        ),
        floatingActionButton:
            Provider.of<TaskCardProvider>(context, listen: true).mode
                ? FloatingActionButton(
                    onPressed: () async {
                      if (deletedTasks.length > 0) {
                        deletedTasks.forEach(
                          (id) async {
                             await Provider.of<Helper>(context,
                                    listen: false)
                                .deleteTask(model: id, mode: mode);
                          },
                        );
                        Provider.of<TaskCardProvider>(context, listen: false)
                            .changeMode(false);
                      }
                      Provider.of<TaskCardProvider>(context, listen: false)
                          .changeMode(false);
                    },
                    backgroundColor: Ui.mainColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(_createRoute());
                    },
                    backgroundColor: Ui.mainColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
        body: TabBarView(
          children: [
            UnfinishedFuture(deletedTasks: deletedTasks, mode: true),
            UnfinishedFuture(deletedTasks: deletedTasks, mode: false),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddNew(),
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
