import 'package:flutter/material.dart';

import '../colos,fonts.dart';

class TextInput extends StatelessWidget {
  final color;
  final controller;
  final lable;
  final validation;
  final icon;
  GlobalKey globalKey;

  TextInput({
    this.color,
    this.controller,
    this.lable,
    this.validation,
    this.icon,
    this.globalKey
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        key:globalKey ,
        obscureText: lable == "password" ? true : false,
        controller: controller,
        cursorColor: color,
        cursorHeight: 25,
        validator: validation,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: lable,
          labelStyle: Ui.main.copyWith(
            color: Ui.thirdColor,
            fontSize: 15,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color == Ui.mainColor ? Ui.secColor : Ui.mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
