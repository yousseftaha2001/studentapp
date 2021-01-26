import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:stduent_app/models/assignmentModel.dart';

import '../colos,fonts.dart';
import 'assignmentview.dart';

class Assignments extends StatelessWidget {
  List<Assignment> ass = [
    Assignment(
      title: "do",
      deadline: DateTime.now(),
      description: "study",
      fileType: "pdf",
    )
  ];
  DateFormat dateFormat = DateFormat.yMMMd();
  DateFormat timeFormat = DateFormat.jm();
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
     
      backgroundColor: Ui.mainColor,
      appBar: AppBar(
        title: Text("Assignemts"),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height / 3,
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
                        ass[0].title,
                        style: Ui.main.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      subtitle: Text(
                        ass[0].description,
                        style: Ui.main.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height / 7,
                      width: size.width,
                      child: ass[0].fileType == "pdf"
                          ?Image.asset("assets/pdf.png")
                          : Image.network(
                              "https://images.unsplash.com/photo-1611105365507-e9ab7e8b84c1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1534&q=80",
                              fit: BoxFit.fill,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "deadline: ${dateFormat.format(ass[0].deadline)}-${ timeFormat.format(ass[0].deadline)}",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6), fontSize: 16),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(toAssignemt());
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
      ),
    );
  }
  Route toAssignemt() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>AssignmentView(),
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
