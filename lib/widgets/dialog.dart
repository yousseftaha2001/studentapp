import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description;

  CustomDialog({
    @required this.title,
    @required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    const double padding = 16.0;
    const double avatarRadius = 40.0;
    return Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          top: avatarRadius + padding,
          left: padding,
          right: padding,
        ),
        margin: EdgeInsets.only(top: avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              this.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("okay"),
              ),
            )
          ],
        ),
      ),
      Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.9),
            radius: avatarRadius,
          ))
    ]);
  }
}