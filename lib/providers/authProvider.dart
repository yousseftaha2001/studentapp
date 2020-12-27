import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stduent_app/models/Exciption.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';

import '../apiEndPoints.dart';

class AuthProvider extends ChangeNotifier {
  final DataBase dataBase = DataBase();
  String token;
  DateTime _expiray;
  String userId;
  bool tryto = false;
  Timer _authTimer;

  bool get isAuth {
    return gettoken != null;
  }

  String get gettoken {
    if (_expiray != null && _expiray.isAfter(DateTime.now()) && token != null) {
      return token;
    }
    return null;
  }

  String get uid {
    if (userId != null) {
      return uid;
    } else {
      return "no token";
    }
  }

  Future<dynamic> signup({String email, String password, String name}) async {
    tryto = true;
    notifyListeners();
    try {
      final response = await http.post(
        Api.signUp,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final data = json.decode(response.body);
      if (data["error"] != null) {
        tryto = false;
        notifyListeners();
        return data["error"]['message'];
      } else {
        token = data['idToken'];
        userId = data['localId'];
        _expiray = DateTime.now().add(
          Duration(
            seconds: int.parse(
              data['expiresIn'],
            ),
          ),
        );
        _autoLogout();
        // print(_userId);
        final database1 = await dataBase.addNewUser(
          user: UserModel(
            age: "20",
            email: email,
            name: name,
            password: password,
            uid: userId,
          ),
          token: token,
          uid: userId,
        );
        if (database1 == true) {
          print("user added to database successfully");
          await setUserData();
          tryto = false;
          notifyListeners();
          return true;
        } else {
          print("error in adding user to database");
          tryto = false;
          notifyListeners();
          return dataBase.toString();
        }
      }
    } catch (error) {
      tryto = false;
      notifyListeners();
      print("erro in auth user ");
      print(error.toString());
      return error.toString();
    }
    // return auth(email: email, password: password, way: 'signUp', name: name);
  }

  Future<dynamic> login(String email, String password) async {
    tryto = false;
    notifyListeners();
    try {
      final response = await http.post(
        Api.logIn,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final data = json.decode(response.body);
      if (data["error"] != null) {
        tryto = false;
        notifyListeners();
        print("error from try to log in (middel)");
        return data["error"]["message"];
      } else {
        token = data['idToken'];
        userId = data['localId'];
        _expiray = DateTime.now().add(
          Duration(
            seconds: int.parse(
              data['expiresIn'],
            ),
          ),
        );
        await setUserData();
        _autoLogout();
        tryto = false;
        notifyListeners();
        print("log in done");
        return true;
      }
    } catch (error) {
      print("error from log in");
      print(error.toString());
      return error.toString();
    }
  }

  Future<void> logOut() async {
    token = null;
    _expiray = null;
    userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> _autoLogout() async {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiray.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    _expiray = expiryDate;
    _autoLogout();
    return true;
  }

  setUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': token,
        'userId': userId,
        'expiryDate': _expiray.toIso8601String(),
      },
    );
    prefs.setString('userData', userData);
  }
}
