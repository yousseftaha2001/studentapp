import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/widgets/notasks.dart';
import 'package:stduent_app/widgets/taskCard.dart';

import '../colos,fonts.dart';

class UnfinishedFuture extends StatelessWidget {
  List<TaskModel> deletedTasks;
  bool mode;

  UnfinishedFuture({this.deletedTasks, @required this.mode});

  @override
  Widget build(BuildContext context) {
    var myData;

    return Consumer<DataBase>(
      builder: (context, data, child) {
        if (mode) {
          myData = data.unfinishedT;
        } else {
          myData = data.finishedT;
        }

        print(myData);
        if (myData.isEmpty) {
          return Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'No tasks Yet !',
                style: Ui.main.copyWith(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        "\n if you are sure that you have tasks please check your internet :)",
                    style: Ui.main.copyWith(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        } else if (myData.first is String) {
          return Center(
            child: Text(
              "No tasks Yet !",
              style: Ui.main.copyWith(
                color: Colors.black,
              ),
            ),
          );
        } else {
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
        }
      },
    );
  }
}
