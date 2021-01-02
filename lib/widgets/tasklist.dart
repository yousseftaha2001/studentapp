import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/TaskCrdProvider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/localNotifications.dart';
import 'package:stduent_app/screens/addTask.dart';
import 'package:stduent_app/screens/taskView.dart';
import 'package:stduent_app/widgets/taskCard.dart';

import '../colos,fonts.dart';
import '../main.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List<String> deletedTasks = [];

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
          ),
        ),
        floatingActionButton:
            Provider.of<TaskCardProvider>(context, listen: true).mode
                ? FloatingActionButton(
                    onPressed: () async {
                      if (deletedTasks.length > 0) {
                        deletedTasks.forEach(
                          (id) async {
                            bool del = await Provider.of<DataBase>(context,
                                    listen: false)
                                .deleteTask(
                              id,
                            );
                            if (del == false) {
                              print("error");
                            }
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
            Consumer<DataBase>(
              //make it selector
              builder: (context, database, child) {
                if (database.unfinishedTasks.isEmpty) {
                  return Center(
                    child: Text("NO Task yet"),
                  );
                } else {
                  return ListView.separated(
                    itemCount: database.unfinishedTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TaskCard(
                          dele: deletedTasks,
                          taskModel: database.unfinishedTasks.toList()[index],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        indent: 40,
                        endIndent: 40,
                        thickness: 1,
                        color: Colors.black.withOpacity(0.5),
                      );
                    },
                  );
                }
              },
            ),
            Container(color: Colors.red),
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
