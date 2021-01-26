import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/taskModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/providers/localNotifications.dart';
import 'package:stduent_app/screens/home.dart';
import 'package:stduent_app/widgets/dialog.dart';
import 'package:stduent_app/widgets/textformwidget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math' as math;

class AddNew extends StatefulWidget {
  final TaskModel taskModel;

  AddNew({this.taskModel});

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  TextEditingController nameCont;

  TextEditingController descriptionCont;

  TextEditingController createdCont;

  TextEditingController deadlineCont;

  bool isnew = true;

  @override
  void initState() {
    super.initState();
    nameCont = TextEditingController();
    descriptionCont = TextEditingController();
    createdCont = TextEditingController();
    deadlineCont = TextEditingController();
    if (widget.taskModel != null) {
      nameCont.text = widget.taskModel.name;
      descriptionCont.text = widget.taskModel.description;
      createdCont.text = widget.taskModel.createdTime;
      deadlineCont.text = widget.taskModel.deadline;
      isnew = false;
    }
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    nameCont.dispose();
    descriptionCont.dispose();
    createdCont.dispose();
    deadlineCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCont.text == "" ? "New task" : nameCont.text),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height / 15),
              TextInput(
                validation: (String name) {},
                color: Ui.mainColor,
                controller: nameCont,
                lable: "TaskName",
                icon: Icon(
                  Icons.assessment,
                  color: Ui.mainColor,
                ),
              ),
              TextInput(
                controller: descriptionCont,
                color: Ui.mainColor,
                lable: "Description",
                icon: Icon(
                  Icons.description,
                  color: Ui.mainColor,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "From",
                  style: Ui.main.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: pickerWidget(createdCont, size),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "To",
                  style: Ui.main.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: pickerWidget(deadlineCont, size),
              ),
              Center(
                child: Consumer<Helper>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: data.makeTask
                          ? CircularProgressIndicator(
                              backgroundColor: Ui.secColor,
                            )
                          : ButtonTheme(
                              minWidth: size.width / 1.3,
                              height: size.height / 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: RaisedButton(
                                onPressed: () async {
                                  isnew
                                      ? await setTask(data)
                                      : await data.updateTask(
                                          tid: widget.taskModel.id,
                                          model: TaskModel(
                                            name: nameCont.value.text,
                                            description: descriptionCont.text,
                                            createdTime: createdCont.text,
                                            deadline: deadlineCont.text,
                                            notiId: widget.taskModel.notiId,
                                          ),
                                        );

                                },
                                color: Ui.secColor,
                                child: Text(
                                  isnew ? "Add Task" : "Update task",
                                  style: Ui.main.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setTask(Helper data) async {
    DateTime time = DateTime.parse(deadlineCont.text);
    if (time.isBefore(DateTime.now()) || time == DateTime.now()) {
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          mode: false,
          title: "Invalid Time",
          description: "please make sure that the deadline is after now!",
          icon: Icon(Icons.error),
        ),
      );
    } else {
      int id = DateTime.now().add(Duration(minutes: 1)).microsecondsSinceEpoch;
      while (id > math.pow(2, 32)) {
        id = id ~/ math.pow(2, 10);
      }
      await data.addTask(
        task: TaskModel(
          name: nameCont.text,
          description: descriptionCont.text,
          createdTime: createdCont.text,
          deadline: deadlineCont.text,
          notiId: id,
        ),
      );

    }
  }



  pickerWidget(TextEditingController controller, Size size) {
    isnew ? controller.text = DateTime.now().toString() : null;

    return DateTimePicker(
      cursorColor: Colors.red,
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: Icon(
        Icons.event,
        color: Ui.mainColor,
      ),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      selectableDayPredicate: (date) {
        return true;
      },
      controller: controller,
    );
  }


}
