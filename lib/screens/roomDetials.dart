import 'package:flutter/material.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/roomModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/screens/assignments.dart';
import 'package:stduent_app/screens/lessons.dart';
import 'package:stduent_app/screens/lessonsList.dart';
import 'package:stduent_app/widgets/dialog.dart';
import 'package:stduent_app/widgets/roomCont.dart';
import 'package:provider/provider.dart';

import 'chatroom.dart';

class RoomDetails extends StatelessWidget {
  String title;
  String rId;
  RoomDetails({
    @required this.title,
    @required this.rId,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Ui.mainColor,
        title: Text(
          title,
          style: Ui.main.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
        ),
        children: [
          RoomContainer(
            height: size.height / 10,
            width: size.width / 3,
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    title: title,
                    rId: rId,
                  ),
                ),
              );
            },
            title: "Chats",
            icon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
          RoomContainer(
            height: size.height / 10,
            width: size.width / 3,
            function: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Assignments(
                    roomId: rId,
                  ),
                ),
              );
            },
            title: "Assignments",
            icon: Icon(
              Icons.work,
              color: Colors.white,
            ),
          ),
          RoomContainer(
            height: size.height / 10,
            width: size.width / 3,
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Lessons(
                    title: title,
                    rid: rId,
                  ),
                ),
              );
            },
            title: "Lessons",
            icon: Icon(
              Icons.tv,
              color: Colors.white,
            ),
          ),
          RoomContainer(
            height: size.height / 10,
            width: size.width / 3,
            function: () async {
              print("Clicked");
              await Provider.of<Helper>(context, listen: false)
                  .exitRoom(roomId: rId);

              // var delete = await Provider.of<DataBase>(context, listen: false)
              //     .deleteRoomId(roomModel.title);
              // if (delete == "done") {
              //   Navigator.pop(context);
              // } else {
              //   await showDialog(
              //     context: context,
              //     builder: (context) => CustomDialog(
              //       title: "Error",
              //       description: delete,
              //       icon: Icon(Icons.error),
              //       mode: false,
              //     ),
              //   );
              // }
            },
            title: "Exit",
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
// return RoomContainer(
// height: size.height / 10,
// width: size.width / 3,
// function: ()async {
// await context.read<DataBase>().deleteRoomId(data[index].title);
// },
// title: "exit",
// icon: Icon(
// Icons.add,
// color: Colors.white,
// ),
// );
