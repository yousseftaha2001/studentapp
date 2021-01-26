import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/widgets/notasks.dart';
import 'package:stduent_app/widgets/taskCard.dart';

import '../colos,fonts.dart';

class UnfinishedFuture extends StatelessWidget {
  List<TaskModel> deletedTasks;
  bool mode;

  UnfinishedFuture({this.deletedTasks, @required this.mode});

  @override
  Widget build(BuildContext context) {
    List<TaskModel> myData = [];

    return Consumer<Helper>(
      builder: (context, data, child) {
        if (mode) {
          myData = data.unfinishedTasks;
        } else {
          myData = data.finishedTasks;
        }
        print(myData);
        if (data.taskIsHere == "null") {
          return Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'No tasks Yet !',
                style: Ui.main.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (data.taskIsHere == "no Internet !") {
          return Center(
              child: Text(
            "no Internet !",
            style: Ui.main.copyWith(fontSize: 18),
          ));
        } else if (data.taskIsHere == "here") {
            return ListView.separated(
              itemCount: myData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TaskCard(
                    dele: deletedTasks,
                    taskModel: myData[index],
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
        } else {
          return Center(
            child: Text(
              data.taskIsHere,
              style: Ui.main.copyWith(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }
}
