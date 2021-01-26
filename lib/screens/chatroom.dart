import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/messagemodel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/widgets/messageshape.dart';
import 'package:stduent_app/widgets/textformwidget.dart';

import '../colos,fonts.dart';

class ChatRoom extends StatefulWidget {
  final String title;
  final String rId;
  ChatRoom({
    @required this.title,
    @required this.rId,
  });
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DataBase dataBase = Provider.of<DataBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Ui.main.copyWith(fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height / 1.3,
              child: StreamBuilder<QuerySnapshot>(
                stream: dataBase.chats(rid: widget.rId),
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.active) {
                    List<Message> chat = [];
                    data.data.docs.forEach((element) {
                      chat.add(Message.fromJson(json: element.data()));
                    });
                    return ListView.builder(
                      reverse: true,
                      itemCount: chat.length,
                      itemBuilder: (context, index) {
                        bool isMe;
                        if (chat[index].sender == dataBase.userId) {
                          isMe = true;
                        } else {
                          isMe = false;
                        }
                        return MessageShape(
                          message: chat[index].message,
                          isMe: isMe,
                          datet: chat[index].created.toDate(),
                          key: ValueKey(data.data.docs[index].id),
                          name:context.read<Helper>().currentUser.name,
                        );
                      },
                    );
                  }
                  if (data.hasError) {
                    return Center(
                      child: Text(data.data.toString()),
                    );
                  }
                  if (!data.hasData) {
                    return Center(
                      child: Text("No messages"),
                    );
                  }
                  if (data.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text(data.data.docs.length.toString()),
                    );
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextInput(
                      controller: messageCont,
                      color: Ui.mainColor,
                      icon: Icon(Icons.message),
                      lable: "your message",
                    ),
                  ),
                  IconButton(
                    color: Ui.mainColor,
                    icon: Icon(Icons.send_outlined),
                    onPressed: () async {
                      if (messageCont.text.isEmpty) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("please enter a message"),
                        ));
                      }else{
                        await dataBase.addMessage(
                          rid: widget.rId,
                          message: Message(
                            sender: dataBase.userId,
                            created: Timestamp.now(),
                            message:messageCont.text
                          ),
                        );
                        messageCont.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
