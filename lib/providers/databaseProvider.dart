import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stduent_app/providers/localNotifications.dart';

class DataBase extends ChangeNotifier {
  final userId;
  final userToken;
  bool tryToUp = false;
  bool addTask = false;
  UserModel currentUser = UserModel();

  List<dynamic> unfinishedT = [];
  List<dynamic> finishedT = [];

  DataBase({this.userId, this.userToken});

  Future<dynamic> addNewUser({UserModel user, String token, String uid}) async {
    print(userId);
    print(token);
    print("he");
    final url = "https://chat-b1734.firebaseio.com/users/$uid.json?auth=$token";
    try {
      await http.post(
        url,
        body: json.encode(
          {
            "name": user.name,
            "email": user.email,
            "uid": user.uid,
            "password": user.password,
          },
        ),
      );
      return true;
    } catch (e) {
      print("error form addnewuser : $e");
      return e;
    }
  }

  Future<void> getUserData() async {
    final point =
        'https://chat-b1734.firebaseio.com/users/$userId.json?auth=$userToken';
    try {
      final response = await http.get(point);
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach(
        (id, userData) {
          if (userData["email"] == currentUser.email) {
            print("done");
          } else {
            currentUser.name = userData["name"];
            currentUser.email = userData["email"];
            currentUser.uid = userData["userId"];
            currentUser.age = "00";
            currentUser.password = userData["password"];

            notifyListeners();
          }
        },
      );
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> updateUserData({String email, String name}) async {
    final point =
        'https://chat-b1734.firebaseio.com/users/$userId.json?auth=$userToken';

    try {
      tryToUp = true;
      final response = await http.patch(
        point,
        body: json.encode(
          {
            'name': name,
            "email": email,
          },
        ),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data["email"] == currentUser.email &&
          data["name"] == currentUser.name) {
        print("done");
      } else {
        print("up");
        currentUser.name = data["name"];
        currentUser.email = data["email"];
        print("user is updated ${currentUser.email}");
        notifyListeners();
      }
      tryToUp = false;
    } catch (error) {
      tryToUp = false;
      print(error.toString() + "here");
    }
  }

  addNewTask({TaskModel task, String date}) async {
    final point =
        "https://chat-b1734.firebaseio.com/tasks/$userId.json?auth=$userToken";

    try {
      addTask = true;
      notifyListeners();
      final response = await http.post(
        point,
        body: json.encode(task.toJson()),
      );
      print(response.body);
      addTask = false;
      await getAllTask();
      notifyListeners();
    } catch (error) {
      addTask = false;
      print(error.toString());
    }
  }

  Future<void> getAllTask() async {
    // final filter = 'orderBy="deadline"&startAt="$first"';
    try {
      final point =
          "https://chat-b1734.firebaseio.com/tasks/$userId.json?auth=$userToken";
      final response = await http.get(point);
      var body = response.body;
      if (body == "null") {
        unfinishedT.add("No tasks !");
        finishedT.add("No tasks !");
      } else {
        print("i m here");
        final tasks = jsonDecode(response.body) as Map<String, dynamic>;
        unfinishedT.clear();
        finishedT.clear();
        // List<TaskModel> un = [];
        // List<TaskModel> fi = [];
        print("sds");
        tasks.forEach(
          (id, info) {
            if (DateTime.parse(tasks[id]["deadline"]).isAfter(DateTime.now())) {
              unfinishedT.add(TaskModel.fromJson(info, id));
              notifyListeners();
            } else {
              finishedT.add(TaskModel.fromJson(info, id));
              notifyListeners();
            }
          },
        );
      }
    } catch (error) {
      print(error.toString() + "error");
    }
  }

  updateTask({String tid, TaskModel updatedTask}) async {
    addTask == true;
    try {
      final point =
          "https://chat-b1734.firebaseio.com/tasks/$userId/$tid.json?auth=$userToken";
      final response = await http.patch(
        point,
        body: json.encode(
          updatedTask.toJson(),
        ),
      );
      addTask = false;
      getAllTask();
      notifyListeners();
      print(response.body);
    } catch (error) {
      print(error.toString());
    }
  }

  deleteTask(TaskModel deletedTask, bool mode) async {
    String tid = deletedTask.id;
    int notId = deletedTask.notiId;
    final point =
        "https://chat-b1734.firebaseio.com/tasks/$userId/$tid.json?auth=$userToken";
    try {
      final response = await http.delete(point);
      if (response.statusCode == 200) {
        if (mode) {
          unfinishedT.remove(deletedTask);
        } else {
          finishedT.remove(deletedTask);
        }
        getAllTask();
        notifyListeners();
        localNotification.flutterLocalNotificationsPlugin.cancel(notId);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err.toString() + "from deleted tasks");
    }
  }
}
