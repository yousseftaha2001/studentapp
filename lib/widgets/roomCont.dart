import 'package:flutter/material.dart';

class RoomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Function function;
  final String title;
  final Icon icon;

  RoomContainer({
    @required this.height,
    @required this.width,
    @required this.function,
    @required this.title,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff132743),
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        width: width,
        margin: EdgeInsets.all(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
