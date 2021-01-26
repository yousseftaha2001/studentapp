import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/roomModel.dart';

import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';

import 'package:stduent_app/screens/roomDetials.dart';

import 'package:stduent_app/widgets/dialog.dart';
import 'package:stduent_app/widgets/roomCont.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Rooms",
          style: Ui.main.copyWith(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => CustomDialog(
              description: "ask your teacher about this password!",
              mode: true,
              password: pass,
              icon: Icon(
                Icons.lock_open,
                color: Ui.mainColor,
                size: 40,
              ),
              title: "Password",
              okayFun: () async {
                await context.read<Helper>().joinToRoom(passord: pass.text);
                pass.clear();
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: "join to Room",
        backgroundColor: Ui.mainColor,
      ),
      body: Consumer<Helper>(
        builder: (context, con, child) {
          if (con.currentUser.rooms.isEmpty) {
            return Center(
              child: Text("You do not have any room"),
            );
          } else if (con.currentUser.rooms.isNotEmpty) {
            List<RoomModel> roomsTitles = con.currentUser.rooms;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: roomsTitles.length,
              itemBuilder: (context, index) {
                return RoomContainer(
                  height: size.height / 10,
                  width: size.width / 3,
                  function: () {
                    Navigator.of(context).push(
                      _toRoom(
                        title: roomsTitles[index].title,
                        rId:roomsTitles[index].roomId ,
                      ),
                    );
                  },
                  title: roomsTitles[index].title,
                  icon: Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Route _toRoom({String title, String rId}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RoomDetails(title: title, rId: rId),
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
