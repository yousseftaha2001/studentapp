import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/providers/TaskCrdProvider.dart';
import 'package:stduent_app/providers/authProvider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/localNotifications.dart';
import 'package:stduent_app/screens/NotificationScreen.dart';
import 'package:stduent_app/screens/home.dart';
import 'package:stduent_app/screens/regester.dart';
import 'package:stduent_app/screens/taskView.dart';
import 'package:stduent_app/screens/tasks.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;



void main() {
  String n=DateTime.now().toIso8601String();
  DateTime newN=DateTime.parse(n);
  print(n);
  print(newN);
  runApp(MyApp());
}



class MyApp extends StatelessWidget{
  static final  GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();
  
  
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
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          routes: {
            "taskView":(context)=>TaskView(),
          },
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
             // home: Tasks(),
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
