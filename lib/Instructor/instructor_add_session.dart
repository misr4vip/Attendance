import 'package:attendance/Instructor/instructor_sessions.dart';
import 'package:attendance/Modles/session_model.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:uuid/uuid.dart';

// ignore: camel_case_types
class instructorAddSession extends StatefulWidget {
  instructorAddSession(
      {Key? key, required this.courseId, required this.courseName})
      : super(key: key);
  String courseId = "";
  String courseName = "";
  @override
  State<instructorAddSession> createState() =>
      _instructorAddSessionState(courseId, courseName);
}

class _instructorAddSessionState extends State<instructorAddSession> {
  _instructorAddSessionState(this.courseId, this.courseName);
  var courseId = "";
  String courseName = "";
  Utilies util = Utilies();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  var myModel = SessionModel.m();
  var date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            util.addTitle("Add New Session"),
            const SizedBox(
              height: 50,
            ),
            util.addTextField(dateController, "session date", () {
              getDate();
            }, readOnly: true),
            util.addTextField(startTimeController, "session start time", () {
              getTime(startTimeController);
            }, readOnly: true),
            util.addTextField(endTimeController, "session end time", () {
              getTime(endTimeController);
            }, readOnly: true),
            util.addButton("Add", () {
              addSession();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => instructor_sessions(
                        courseId: courseId,
                        courseName: courseName,
                      )));
            })
          ],
        ),
      ),
    );
  }

  Future getDate() async {
    DateTime? myDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date,
        lastDate: DateTime(2050));
    if (myDate == null) {
      return;
    }
    setState(() {
      var mDay = myDate.day;
      var mMonth = myDate.month;
      var mYear = myDate.year;
      dateController.text = "$mDay/$mMonth/$mYear";
    });
  }

  Future getTime(TextEditingController controller) async {
    TimeOfDay? myTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (myTime == null) {
      return;
    }
    setState(() {
      controller.text = myTime.format(context);
    });
  }

  Future addSession() async {
    if (dateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      showCustomToast("invalid input data");
    } else {
      var sessionId = Uuid().v1().toString();
      var sessionModel = SessionModel.n(courseId, dateController.text,
          startTimeController.text, endTimeController.text, sessionId);
      FirebaseDatabase.instance
          .ref()
          .child(constants.sessions)
          .child(courseId)
          .child(sessionId)
          .set(sessionModel.toDictionary());
      showCustomToast("session Added Successfully");
    }
  }
}
