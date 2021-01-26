import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/models/userModel.dart';
import 'package:stduent_app/providers/authProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/widgets/textformwidget.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import '../colos,fonts.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();
  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      name.text = context.read<Helper>().currentUser.name;
      email.text = context.read<Helper>().currentUser.email;
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: Ui.main.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Material(
                elevation: 5,
                child: Container(
                  color: Colors.white,
                  width: size.width,
                  height: size.height / 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 50,
                      horizontal: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Ui.mainColor,
                        ),
                        Container(
                          width: size.width / 2,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Consumer<Helper>(
                                builder: (context, data, __) {
                                  print(1);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data.currentUser.email == null
                                            ? "email"
                                            : data.currentUser.email,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        data.currentUser.name == null
                                            ? "name"
                                            : data.currentUser.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: size.height / 2.5,
                                    width: size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Text(
                                            "Update your Info",
                                            style: Ui.main.copyWith(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        TextInput(
                                          color: Ui.mainColor,
                                          controller: name,
                                          lable: "username",
                                          icon: Icon(
                                            Icons.person,
                                            color: Ui.mainColor,
                                          ),
                                          validation: (String va) {},
                                        ),
                                        TextInput(
                                          color: Ui.mainColor,
                                          controller: email,
                                          lable: "email",
                                          icon: Icon(
                                            Icons.email,
                                            color: Ui.mainColor,
                                          ),
                                          validation: (String va) {},
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 30,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ButtonTheme(
                                                buttonColor: Ui.mainColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                                child: Selector<DataBase, bool>(
                                                  selector: (_, data) =>
                                                      data.tryToUp,
                                                  builder: (context, up, __) {
                                                    return up
                                                        ? CircularProgressIndicator()
                                                        : RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              // await context
                                                              //     .read<
                                                              //         DataBase>()
                                                              //     .updateUserData(
                                                              //       updated: {
                                                              //         "email":email.text,
                                                              //         "name":name.text,
                                                              //       }
                                                              //     );
                                                              // Navigator.pop(
                                                              //     context);
                                                            },
                                                            child: Text(
                                                              "Done",
                                                              style: Ui.main
                                                                  .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ),
                                              ButtonTheme(
                                                buttonColor: Ui.secColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "cancel",
                                                    style: Ui.main.copyWith(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
