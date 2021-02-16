import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/AssignmentSol.dart';
import 'package:stduent_app/models/comment.dart';
import 'package:stduent_app/models/roomModel.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:stduent_app/widgets/dialog.dart';
import 'databaseProvider.dart';
import 'package:stduent_app/services.dart';

import 'localNotifications.dart';

class Helper extends ChangeNotifier {
  BuildContext context = MyService.navigation.currentContext;
  UserModel currentUser = UserModel();
  List<TaskModel> unfinishedTasks = [];
  List<TaskModel> finishedTasks = [];
  List<String> roomsIds = ["No Rooms"];
  bool makeTask = false;
  bool join = false;
  String taskIsHere = "no";
  final DataBase dataBase =
      Provider.of<DataBase>(MyService.context, listen: false);
  Future<void> getUserDataLocal() async {
    try {
      var getUser = await dataBase.getUserData();
      if (getUser is String) {
        print("error from get user : $getUser");
        currentUser = UserModel();
      } else {
        if (getUser is Map<String, dynamic>) {
          getUser.forEach(
            (key, value) {
              print(value);
              if (key == "info") {
                currentUser = UserModel.fromJson(value);
                print(currentUser.name);
                currentUser.rooms = [];
                notifyListeners();
              } else {
                print(value);
                var rooms = value as Map<String, dynamic>;
                rooms.forEach(
                  (key, value) {
                    currentUser.rooms.add(RoomModel.fromJson(value, key));
                  },
                );
                notifyListeners();
              }
            },
          );
        } else {
          currentUser = UserModel();
        }
      }
    } catch (e) {}
  }

  Future<void> getTasksLocal() async {
    try {
      var tasks = await dataBase.getAllTasks();
      List<TaskModel> un = [];
      List<TaskModel> fin = [];
      if (tasks == "null") {
        taskIsHere = "null";
        notifyListeners();
      } else if (tasks is Map<String, dynamic>) {
        taskIsHere = "here";
        notifyListeners();
        tasks.forEach(
          (id, info) {
            if (DateTime.parse(tasks[id]["deadline"]).isAfter(DateTime.now())) {
              un.add(TaskModel.fromJson(info, id));
            } else {
              fin.add(TaskModel.fromJson(info, id));
            }
          },
        );
        unfinishedTasks = un;
        finishedTasks = fin;
        notifyListeners();
      } else if (tasks == "no Internet !") {
        taskIsHere = "no Internet !";
        notifyListeners();
      } else {
        taskIsHere = tasks.toString();
        notifyListeners();
      }
    } catch (e) {
      taskIsHere = e.toString();
      notifyListeners();
      print(e.toString());
    }
  }

  Future<void> addTask({TaskModel task}) async {
    makeTask = true;
    notifyListeners();
    try {
      print("try to add task");
      String add = await dataBase.addNewTask(task: task);
      print(add);
      switch (add) {
        case "done":
          makeTask = false;
          setNotification(task);
          await getTasksLocal();
          Navigator.pop(context);
          // notifyListeners();
          // Navigator.pop(context);
          break;
        default:
          await showD(add);
          makeTask = false;
          notifyListeners();
          break;
      }
    } catch (e) {
      makeTask = false;
      print(e.toString());
    }
  }

  Future<void> updateTask({String tid, TaskModel model}) async {
    makeTask = true;
    notifyListeners();
    try {
      String up = await dataBase.updateTask(
        tid: tid,
        updatedTask: model,
      );
      switch (up) {
        case "Done":
          localNotification.flutterLocalNotificationsPlugin
              .cancel(model.notiId);
          setNotification(model);
          await getTasksLocal();
          makeTask = false;
          Navigator.of(context).pop();
          break;
        default:
          await showD(up);
          makeTask = false;
          notifyListeners();
          break;
      }
    } catch (e) {
      makeTask = false;
      print(e.toString());
    }
  }

  Future<void> deleteTask({TaskModel model, bool mode}) async {
    try {
      String delete = await dataBase.deleteTask(tid: model.id);
      switch (delete) {
        case "done":
          if (mode) {
            unfinishedTasks.remove(model);
          } else {
            finishedTasks.remove(model);
          }
          notifyListeners();
          localNotification.flutterLocalNotificationsPlugin
              .cancel(model.notiId);
          await getTasksLocal();
          break;
        default:
          await showD(delete);
          break;
      }
    } catch (er) {
      print(er.toString());
    }
  }

  Future<void> joinToRoom({String passord}) async {
    join = true;
    notifyListeners();
    try {
      var joining = await dataBase.joinToRoom(
        password: passord,
        user: currentUser,
      );
      print(joining is List);
      //problem is add room id to user
      if (joining is List<String>) {
        String addToUser = await dataBase.addRoomToUser(room: joining);
        print(addToUser);
        if (addToUser == "done") {
          print("room has added to user");
          join = false;
          await getUserDataLocal();
          Navigator.of(context).pop();
          notifyListeners();
        } else {
          await showD(addToUser);
          join = false;
          notifyListeners();
        }
      } else {
        await showD(joining);
        join = false;
        notifyListeners();
      }
    } catch (error) {}
  }

  Future<void> exitRoom({String roomId}) async {
    //first remove student from firestore
    //sceond remove roomId from students database
    try {
      String first = await dataBase.deleteUserFromRoom(roomId);
      if (first == "done") {
        var sec = await dataBase.deleteRoomFromUser(roomId: roomId);
        if (sec is bool) {
          if (sec) {
            await getUserDataLocal();
            Navigator.of(context).pop();
            print("done+1");
          } else {
            await showD("please check your internet");
          }
        } else {
          await showD(sec);
        }
      } else {
        await showD(first);
      }
    } catch (e) {
      print(e.toString());
      await showD(e.toString());
    }
  }

  uploadsolution(
      {List<PlatformFile> files, String comment, String roomId}) async {
    try {
      List<String> urls = await dataBase.uploadSoltoStorage(
        files: files,
        way: "assignemntsSolutions",
        type: files.first.extension,
      );
      if (!urls.contains("error")) {
        SolutionModel model = SolutionModel(
          studentName: currentUser.name,
          priviteComment: comment,
          attachments: urls,
          filesType: files.first.extension,
        );
        await dataBase.uploadSolutionToTeacher(
          rId: roomId,
          solutionModel: model,
        );
      } else {
        showD("please check your internet");
      }
    } catch (e) {
      showD(e.toString());
    }
  }

  void addingComments(
      {String rid, String way, String docId, String body}) async {
    Comment com = Comment(
      name: currentUser.name,
      comment: body,
      time: DateTime.now(),
    );
    await Provider.of<DataBase>(context, listen: false).addComment(
      rid: rid,
      way: way,
      docId: docId,
      comment: com,
    );
  }

  showD(String des) {
    showDialog(
      context: MyService.context,
      builder: (context) => CustomDialog(
        title: "Error",
        description: des,
        icon: Icon(
          Icons.error,
          size: 35,
        ),
        mode: false,
      ),
    );
  }

  setNotification(TaskModel model) async {
    await localNotification.showNotification(
      taskModel: TaskModel(
        name: model.name,
        description: model.description,
        notiId: model.notiId,
        deadline: model.deadline,
      ),
    );
  }
}
