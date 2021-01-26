import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String message;
  Timestamp created;
  Message({this.message, this.created, this.sender});
  Message.fromJson({Map<String, dynamic> json}) {
    sender = json["sender"];
    message = json["message"];
    created = json["created"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data["message"] = this.message;
    data["sender"] = this.sender;
    data["created"] = this.created;
    return data;
  }
}
