import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/widgets/textformwidget.dart';

import '../colos,fonts.dart';

class CustomDialog extends StatelessWidget {
  final String title, description;
  final Icon icon;
  final bool mode;
  TextEditingController password;
  Function okayFun;
  Function cancelFun;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.icon,
    @required this.mode,
    this.password,
    this.cancelFun,
    this.okayFun,
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
    return Stack(
      children: <Widget>[
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
              mode
                  ? TextInput(
                      color: Ui.mainColor,
                      controller: password,
                      lable: "password",
                      icon: Icon(
                        Icons.lock_open,
                        color: Ui.mainColor,
                      ),
                    )
                  : Container(),
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
                child: mode
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: okayFun,
                            child: Text("okay"),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("cancel"),
                          ),
                        ],
                      )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: okayFun,
                            child: Text("okay"),
                          ),
                          FlatButton(
                            onPressed: cancelFun,
                            child: Text("cancel"),
                          )
                        ],
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
            child: icon,
          ),
        )
      ],
    );
  }
}
