import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stduent_app/models/AssignmentSol.dart';
import 'package:stduent_app/models/messagemodel.dart';
import 'package:stduent_app/models/roomModel.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stduent_app/providers/localNotifications.dart';

class DataBase extends ChangeNotifier {
  final userId;
  final userToken;
  bool tryToUp = false;
  bool join = false;

  DataBase({this.userId, this.userToken});

  FirebaseFirestore fire = FirebaseFirestore.instance;

  Future<dynamic> joinToRoom({String password, UserModel user}) async {
    try {
      QuerySnapshot doc = await fire
          .collection("Rooms")
          .where("password", isEqualTo: password)
          .get();
      if (doc.docs.isNotEmpty) {
        int maxStudent = doc.docs.first.data()["Maximum Students"];
        String roomId = doc.docs.first.id;
        var students =
            fire.collection("Rooms").doc(roomId).collection("students").get();
        int studentColl = await students.then((value) => value.docs.length);
        if (studentColl < maxStudent) {
          print("there is space to new stududent");
          print(user.email);
          await fire
              .collection("Rooms")
              .doc(roomId)
              .collection('students')
              .doc(userId)
              .set(user.toJson());
          List<String> room = [
            doc.docs.first.data()["title"],
            roomId,
          ];
          return room;
        } else {
          return "no space";
        }
      } else {
        return "wrong password";
      }
    } catch (error) {
      print(error.toString() + " from join function");
      return "Ooops we have an error,please try later";
    }
  }

  Future<dynamic> getRoomData({@required String roomId}) async {
    try {
      DocumentSnapshot room = await fire.collection("Rooms").doc(roomId).get();
      if (room.exists) {
        return room.data();
      } else {
        return "no room found";
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<dynamic> addRoomToUser({List<String> room}) async {
    final url =
        "https://chat-b1734.firebaseio.com/users/$userId/rooms.json?auth=$userToken";
    try {
      var response = await http.patch(
        url,
        body: json.encode({room[1]:{"title": room[0]}}),
      );
      if (response.statusCode == 200) {
        return "done";
      } else {
        return "no internet";
      }
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<dynamic> addNewUser({
    UserModel user,
    String token,
    String uid,
  }) async {
    final url =
        "https://chat-b1734.firebaseio.com/users/$uid/info.json?auth=$token";
    try {
      await http.put(
        url,
        body: json.encode(user.toJson()),
      );
      return true;
    } catch (e) {
      print("error form add new user : $e");
      return e;
    }
  }

  Future<dynamic> getUserData() async {
    final point =
        'https://chat-b1734.firebaseio.com/users/$userId.json?auth=$userToken';
    try {
      final response = await http.get(point);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.isNotEmpty) {
          return data;
        } else {
          return "No data";
        }
      } else {
        return "no internet";
      }
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  // Future<void> updateUserData({Map<String, dynamic> updated}) async {
  //   final point =
  //       'https://chat-b1734.firebaseio.com/users/$userId/.json?auth=$userToken';
  //
  //   try {
  //     tryToUp = true;
  //     final response = await http.patch(
  //       point,
  //       body: json.encode(updated),
  //     );
  //     final data = json.decode(response.body) as Map<String, dynamic>;
  //     if (data["email"] == currentUser.email &&
  //         data["name"] == currentUser.name) {
  //       print("done");
  //     } else {
  //       print("up");
  //       currentUser.name = data["name"];
  //       currentUser.email = data["email"];
  //       print("user is updated ${currentUser.email}");
  //       notifyListeners();
  //     }
  //     tryToUp = false;
  //   } catch (error) {
  //     tryToUp = false;
  //     print(error.toString() + "here");
  //   }
  // }
  // Future<void> getAllDataOfRooms() async {
  //   print(currentUser.rooms);
  //   try {
  //     currentUser.rooms.forEach(
  //           (title, id) async {
  //         var room = await getRoomData(roomId: id);
  //         if (room is String) {
  //           deleteRoomId(title);
  //         } else {
  //           if(_rooms.first is String){
  //             _rooms.clear();
  //             _rooms.add(RoomModel.fromJson(await getRoomData(roomId: id), id));
  //           }else{
  //             _rooms.add(RoomModel.fromJson(await getRoomData(roomId: id), id));
  //           }
  //         }
  //       },
  //     );
  //   } catch (error) {
  //     print("error from get all tasls: $error");
  //   }
  // }
  Future<String> addNewTask({TaskModel task}) async {
    final point =
        "https://chat-b1734.firebaseio.com/tasks/$userId.json?auth=$userToken";
    try {
      final response = await http.post(
        point,
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        if (response.body != "null") {
          return "done";
        } else {
          return response.body.toString();
        }
      } else {
        return "no internet!";
      }
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<dynamic> getAllTasks() async {
    try {
      final point =
          "https://chat-b1734.firebaseio.com/tasks/$userId.json?auth=$userToken";
      final response = await http.get(point);
      var body = response.body;
      var de = response.statusCode;
      if (de == 200) {
        if (body == "null") {
          return "null";
        } else {
          print("i m here");
          final tasks = jsonDecode(response.body) as Map<String, dynamic>;
          return tasks;
        }
      } else {
        notifyListeners();
        return "no Internet !";
      }
    } catch (error) {
      print(error.toString() + "error");
      return error.toString();
    }
  }

  Future<String> updateTask({String tid, TaskModel updatedTask}) async {
    try {
      final point =
          "https://chat-b1734.firebaseio.com/tasks/$userId/$tid.json?auth=$userToken";
      final response = await http.patch(
        point,
        body: json.encode(
          updatedTask.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        return "Done";
      } else {
        return "no internet";
      }
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<String> deleteTask({String tid}) async {
    
    final point =
        "https://chat-b1734.firebaseio.com/tasks/$userId/$tid.json?auth=$userToken";
    try {
      final response = await http.delete(point);
      if (response.statusCode == 200) {
        
        return "done";
      } else {
        return "no internet";
      }
    } catch (err) {
      print(err.toString() + "from deleted tasks");
      return err.toString();
    }
  }

  Future<String> deleteUserFromRoom(String roomId) async {
    String re;
    try {
      await fire
          .collection("Rooms")
          .doc(roomId)
          .collection("students")
          .doc(userId)
          .delete()
          .then(
        (val) {
          print("studnet deleted suc");
          re = "done";
        },
      ).catchError(
        (er) {
          print("we have an error in delete user");
          re = er.toString();
        },
      );
      return re;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }
  Future<dynamic>deleteRoomFromUser({String roomId})async{
    try {
      print(roomId);
         final point =
        'https://chat-b1734.firebaseio.com/users/$userId/rooms/$roomId.json?auth=$userToken';
        final response=await http.delete(point);
        return response.statusCode==200;
    } catch (e) {
      return e.toString();
    }
  }
   addMessage({String rid, Message message }) async {
    await fire
        .collection("Rooms")
        .doc(rid)
        .collection("Chats")
        .add(message.toJson());
  }
  Stream<QuerySnapshot> chats({String rid}) {
    return fire
        .collection("Rooms")
        .doc(rid)
        .collection("Chats")
        .orderBy("created",descending: true)
        .snapshots();
  }

  // deleteRoomId(String title) async {
  //   print("try to delete");
  //   final point =
  //       "https://chat-b1734.firebaseio.com/users/$userId/rooms/$title.json?auth=$userToken";
  //   try {
  //     final response = await http.delete(point);
  //     if(_rooms.length==1){
  //       _rooms.removeWhere((e){
  //         if(e is RoomModel){
  //           var room=e;
  //           if(room.title==title){
  //             return true;
  //           }else{
  //             return false;
  //           }
  //         }else{
  //           return  false;
  //         }
  //       });
  //       _rooms.add("no Room");
  //     }else{
  //       _rooms.removeWhere((e){
  //         if(e is RoomModel){
  //           var room=e;
  //           if(room.title==title){
  //             return true;
  //           }else{
  //             return false;
  //           }
  //         }else{
  //           return  false;
  //         }
  //       });
  //     }
  //     notifyListeners();
  //     return "done";
  //   } catch (e) {
  //     print(e.toString());
  //     return e.toString();
  //   }
  // }

}
