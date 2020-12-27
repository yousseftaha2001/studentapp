import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/Exciption.dart';
import 'package:stduent_app/providers/authProvider.dart';
import 'package:stduent_app/widgets/textformwidget.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool mode = true;

  convertMode(bool state) {
    mode = state;
  }

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  final keyF = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("SignUpScreen has built");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            SizedBox(height: size.height * 0.03),
            SwitchListTile(
              value: mode,
              onChanged: (bool newVal) {
                setState(() {
                  convertMode(newVal);
                  name.clear();
                  email.clear();
                  password.clear();
                });
              },
              activeColor: Ui.secColor,
              inactiveThumbColor: Ui.mainColor,
              title: Text(
                mode ? "Login" : "SignUp",
                style: Ui.main.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(mode ? "Switch to Sign Up" : "Switch to login"),
            ),
            SizedBox(width: size.width / 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Welcome",
                        style: Ui.main.copyWith(
                          color: Colors.black45,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  mode
                      ? Row(
                          children: [
                            Text(
                              "Back",
                              style: Ui.main.copyWith(
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Form(
              key: keyF,
              child: Column(
                children: [
                  mode
                      ? Container()
                      : TextInput(
                          color: Ui.mainColor,
                          lable: "username",
                          icon: Icon(Icons.person),
                          controller: name,
                          validation: (String text) {
                            if (text.length < 2) {
                              return "please enter a good name!";
                            } else {
                              return null;
                            }
                          },
                        ),
                  TextInput(
                    color: Ui.mainColor,
                    lable: "email",
                    icon: Icon(Icons.email),
                    controller: email,
                    validation: (String text) {
                      if (text.length < 2) {
                        return "please enter a good email!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextInput(
                    color: Ui.mainColor,
                    lable: "password",
                    icon: Icon(Icons.admin_panel_settings_sharp),
                    controller: password,
                    validation: (String text) {
                      if (text.length < 2) {
                        return "please enter a good password!";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height / 5),
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                return auth.tryto
                    ? CircularProgressIndicator()
                    : ButtonTheme(
                        buttonColor: mode ? Ui.secColor : Ui.mainColor,
                        minWidth: size.width / 2,
                        height: size.height / 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: RaisedButton(
                          onPressed: () async {
                            var val;
                            if (keyF.currentState.validate()) {
                              try {
                                mode
                                    ? val = await logInMethod(context)
                                    : val = await signUpMehtod(context);
                                print(val);
                                if (val != true) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('An Error Occurred!'),
                                      content: Text(val.toString()),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } catch (err) {
                                print(err.toString());
                              }
                            }
                          },
                          child: Text(
                            mode ? "Login" : "SignUp",
                            style: Ui.main,
                          ),
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }

  signUpMehtod(BuildContext ctx) async {
    final val = await ctx.read<AuthProvider>().signup(
          email: email.text,
          name: name.text,
          password: password.text,
        );
    return val;
  }

  logInMethod(BuildContext ctx) async {
    final val = await ctx.read<AuthProvider>().login(
          email.text,
          password.text,
        );
    return val;
  }
}
