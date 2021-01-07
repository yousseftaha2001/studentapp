import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/providers/TaskCrdProvider.dart';
import 'package:stduent_app/providers/authProvider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/screens/home.dart';
import 'package:stduent_app/screens/regester.dart';
import 'package:stduent_app/services.dart';


import 'screens/test.dart';

void main() {
  String n = DateTime.now().toIso8601String();
  DateTime newN = DateTime.parse(n);
  print(n);
  print(newN.millisecondsSinceEpoch);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DataBase>(
          create: (_) => DataBase(),
          update: (_, auth, __) =>
              DataBase(userId: auth.userId, userToken: auth.token),
        ),
        ChangeNotifierProvider(create: (_) => TaskCardProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          navigatorKey: Service.navigation,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          routes: {

            "test": (context) => Test(),
          },
          debugShowCheckedModeBanner: false,

          // home: TRY(),
          home: FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authSnap) {
              if (authSnap.connectionState == ConnectionState.waiting) {
                print(authSnap.data);
                return Center(child: CircularProgressIndicator());
              } else if (authSnap.connectionState == ConnectionState.done) {
                return authSnap.data ? Home() : Register();
              } else {
                return Text("data2");
              }
            },
          ),
        ),
      ),
    );
  }
}
