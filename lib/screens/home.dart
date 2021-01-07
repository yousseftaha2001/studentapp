import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/screens/profile.dart';
import 'package:stduent_app/screens/room.dart';
import 'file:///C:/Users/yousseftaha/projects/studentapp/lib/screens/tasklist.dart';

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
    Room(),
    Profile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (init) {
      context.read<DataBase>().getUserData();
      context.read<DataBase>().getAllTask();
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
