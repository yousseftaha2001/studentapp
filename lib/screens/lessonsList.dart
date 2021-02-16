import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/lesson.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/screens/lessons.dart';

class Lessons extends StatelessWidget {
  final String title;
  final String rid;
  List<Lesson> lessons = [];
  DateFormat dateFormat = DateFormat.yMMMd();
  Lessons({this.title, this.rid});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataBase = Provider.of<DataBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataBase.lessons(rid: rid),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.active) {
            print(data.data.docs.first.data()["fileType"]);
            if (data.data.docs.length > 0) {
              data.data.docs.forEach(
                (lesson) {
                  lessons.add(Lesson.fromJson(
                    json: lesson.data(),
                    iD: lesson.id,
                  ));
                },
              );
              return ListView.builder(
                itemCount: data.data.docs.length,
                itemBuilder: (context, index) {
                  print(lessons.first.lId);
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
                                lessons[index].title,
                                style: Ui.main.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                lessons[index].description,
                                style: Ui.main.copyWith(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height / 7,
                              width: size.width,
                              child: defineType(
                                lessons[index].fileType,
                                lessons[index].fileUrls.first,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "created: ${dateFormat.format(lessons[index].created)}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                            ),
                            Center(
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LessonView(
                                        lesson: lessons[index],
                                        rid: rid,
                                        title: title,
                                      ),
                                    ),
                                  );
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

  Widget defineType(String type, String url) {
    if (type == "photo") {
      return Image.network(
        url,
        fit: BoxFit.fitHeight,
      );
    } else if (type == "Pdf") {
      return Image.asset("assets/pdf.png");
    } else {
      return Image.asset("assets/video.png");
    }
  }
}
