import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/assignmentModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';

import '../colos,fonts.dart';
import 'assignmentview.dart';

class Assignments extends StatelessWidget {
  List<Assignment> assignments = [];
  DateFormat dateFormat = DateFormat.yMMMd();
  DateFormat timeFormat = DateFormat.jm();
  final String roomId;
  Assignments({this.roomId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DataBase dataBase = Provider.of<DataBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Ui.mainColor,
      appBar: AppBar(
        title: Text("Assignemts"),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataBase.assignemtns(rid: roomId),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.active) {
            print(data.data.docs.first.data()["fileType"]);
            if (data.data.docs.length > 0) {
              data.data.docs.forEach(
                (assignemnt) {
                  assignments.add(Assignment.fromJson(json: assignemnt.data()));
                },
              );
              return ListView.builder(
                itemCount: data.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height / 2.9,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.assessment_rounded,
                                color: Ui.mainColor,
                              ),
                              title: Text(
                                assignments[index].title,
                                style: Ui.main.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                assignments[index].description,
                                style: Ui.main.copyWith(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height / 7,
                              width: size.width,
                              child: assignments[index].fileType == "Pdf"
                                  ? Image.asset("assets/pdf.png")
                                  : Image.network(
                                      assignments[index].fileUrls.first,
                                      fit: BoxFit.fitHeight,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "deadline: ${dateFormat.format(assignments[index].deadline)}-${timeFormat.format(assignments[index].deadline)}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                            ),
                            Center(
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(toAssignemt(
                                      ass: assignments[index], rid: roomId));
                                },
                                child: Text(
                                  'Open',
                                  style: Ui.main.copyWith(
                                    fontSize: 18,
                                    color: Ui.mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("you do not have assignments now"),
              );
            }
          } else if (data.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("We have an error"),
            );
          }
        },
      ),
    );
  }

  Route toAssignemt({Assignment ass, String rid}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AssignmentView(
        assignment: ass,
        roomId: rid,
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
