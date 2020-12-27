// import 'package:flutter/material.dart';
// import 'package:stduent_app/providers/localNotifications.dart';
// import 'package:stduent_app/screens/NotificationScreen.dart';
// import 'package:stduent_app/screens/tasks.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   int nid = 0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     tz.initializeTimeZones();
//     localNotification.init();
//     localNotification
//         .setListenerForLowerVersions(onNotificationInLowerVersions);
//     localNotification.onNoitificationClick(Tasks.onNotificationClick);
//   }
//     onNotificationInLowerVersions(NotificationBody receivedNotification) {
//     print('Notification Received ${receivedNotification.id}');
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           onPressed: () async {
//             String name = "go to gym";
//             String body = "Task time has come";
//             tz.TZDateTime shuadle = tz.TZDateTime.now(tz.local).add(
//               const Duration(
//                 seconds: 5,
//               ),
//             );
//             nid++;
//             await localNotification.showNotification(
//               id: nid,
//               title: name,
//               body: body,
//               scheduleTime: shuadle,
//             );
//           },
//           child: Text("Set Noti"),
//         ),
//       ),
//     );
//   }
// }
