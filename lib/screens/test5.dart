import 'package:flutter/material.dart';
import 'package:stduent_app/screens/test3.dart';

class TRY extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Test2(),
              ),
            );
          },
          child: Text("dsas"),
        ),
      ),
    );
  }
}
