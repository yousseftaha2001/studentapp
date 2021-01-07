import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stduent_app/colos,fonts.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool mode = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      setState(() {
        mode = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: mode
          ? CircularProgressIndicator()
          : Center(
              child: Text(
                "No tasks Yet !",
                style: Ui.main.copyWith(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ),
    );
  }
}
