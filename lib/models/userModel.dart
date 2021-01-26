import 'package:stduent_app/models/roomModel.dart';

class UserModel {
  String name = "";
  String age = "";
  String password = "";
  String email = "";
  String uid = "";

  
  List<RoomModel>rooms;

  UserModel({
    this.age,
    this.email,
    this.name,
    this.password,
    this.uid,
    this.rooms,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    age = json["age"];
    password = json["password"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = this.name;
    data["age"] = this.age;
    data["email"] = this.email;
    data["uid"] = this.uid;
    data["password"] = this.password;
    return data;
  }
}
