import 'package:flutter/material.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataBase extends ChangeNotifier {
  final userId;
  final userToken;
  bool tryToUp = false;
  bool addTask = false;
  UserModel useri = UserModel();
  List<TaskModel> unfinishedTasks = [];
  List<TaskModel> finishedTasks = [];

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
          if (userData["email"] == useri.email) {
            print("done");
          } else {
            useri.name = userData["name"];
            useri.email = userData["email"];
            useri.uid = userData["userId"];
            useri.age = "00";
            useri.password = userData["password"];

            notifyListeners();
          }
        },
      );
    } catch (errro) {
      print(errro.toString());
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
      if (data["email"] == useri.email && data["name"] == useri.name) {
        print("done");
      } else {
        print("up");
        useri.name = data["name"];
        useri.email = data["email"];
        print("user is updated ${useri.email}");
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
      getAllTask();
      notifyListeners();
    } catch (error) {
      addTask = false;
      print(error.toString());
    }
  }

  Future<dynamic> getAllTask({bool today}) async {
    // final filter = 'orderBy="deadline"&startAt="$first"';
    try {
      final point =
          "https://chat-b1734.firebaseio.com/tasks/$userId.json?auth=$userToken";
      final response = await http.get(point);
      // print(response.headers);
      if (response.body.isEmpty) {
        return null;
      } else {
        final tasks = jsonDecode(response.body) as Map<String, dynamic>;
        // unfinishedTasks.clear();
        // finishedTasks.clear();
        List<TaskModel>un=[];
        List<TaskModel>fi=[];
        if(tasks.length>=1){
          tasks.forEach(
          (id, info) {
            if (DateTime.parse(tasks[id]["deadline"]).isAfter(DateTime.now())) {
                // unfinishedTasks.add(TaskModel.fromJson(info, id));
              un.add(TaskModel.fromJson(info, id));
              unfinishedTasks=un;
              notifyListeners();
            } else {
                // finishedTasks.add(TaskModel.fromJson(info, id));
              fi.add(TaskModel.fromJson(info, id));
              finishedTasks=fi;
              notifyListeners();
            }
          },
        );
        }
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

  deleteTask(String tid) async {
    final point =
        "https://chat-b1734.firebaseio.com/tasks/$userId/$tid.json?auth=$userToken";
    try {
      final response = await http.delete(point);
      if (response.statusCode == 200) {
        
        getAllTask();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err.toString() + "from delet tasks");
    }
  }
}
