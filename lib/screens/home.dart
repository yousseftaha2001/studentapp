import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/screens/profile.dart';
import 'package:stduent_app/screens/room.dart';
import 'package:stduent_app/screens/tasklist.dart';
import 'package:stduent_app/screens/test.dart';
import 'package:stduent_app/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool init = true;
  List<Widget> pages = [
    TasksList(),
    Rooms(),
    Profile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      print("we wiil cal");
      await Provider.of<Helper>(context, listen: false).getUserDataLocal();
      Provider.of<Helper>(context, listen: false).getTasksLocal();
    }
    // context.read<Helper>().getAllDataOfRooms();
    init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.work,
            ),
            label: "My tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
            ),
            label: "Rooms",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "My Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        selectedFontSize: 14,
        unselectedFontSize: 11,
        backgroundColor: Color(0xff132743),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
