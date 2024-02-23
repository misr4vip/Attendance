import 'package:attendance/Instructor/instructor_add_session.dart';
import 'package:attendance/Instructor/instructor_attendance.dart';
import 'package:attendance/Modles/session_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Utils/Consts.dart';

import '../Utils/Utils.dart';

class instructor_sessions extends StatefulWidget {
  instructor_sessions(
      {Key? key, required this.courseId, required this.courseName})
      : super(key: key);
  var courseId = "";
  var courseName = "";
  @override
  State<instructor_sessions> createState() =>
      _instructor_sessionsState(courseId, courseName);
}

class _instructor_sessionsState extends State<instructor_sessions> {
  _instructor_sessionsState(this.courseId, this.courseName);
  var modles = [SessionModel.m()];
  var courseId = "";
  var courseName = "";
  @override
  void initState() {
    modles.clear();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("course Session"),
      ),
      body: modles.isNotEmpty
          ? ListView.builder(
              //prototypeItem: Row(children: [Text("Semster")]),
              itemCount: modles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " date: ${modles[index].sessionDate} ",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "  start at: ${modles[index].sessionStartTime}     end at: ${modles[index].sessionEndtime}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                removeSession(
                                    courseId, modles[index].sessionId, index);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.red)),
                              child: Text(
                                "delete",
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                attendanceTapped(index);
                              },
                              child: Text("Attendance")),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
              "Sorry no data to display .",
              style: TextStyle(fontSize: 22),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => instructorAddSession(
                courseId: courseId, courseName: courseName),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ///  function to get courses from database
  Future getData() async {
    try {
      modles.clear();
      var dataSnap = await FirebaseDatabase.instance
          .ref()
          .child(constants.sessions)
          .child(courseId)
          .get();
      if (dataSnap.exists) {
        for (var snapShot in dataSnap.children) {
          setState(() {
            var sessionModel = SessionModel.z(snapShot.value as Map);
            if (sessionModel.courseid == courseId) {
              modles.add(sessionModel);
            }
          });
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future removeSession(String courseId, String sessionId, int index) async {
    try {
      // modles.clear();
      await FirebaseDatabase.instance
          .ref()
          .child(constants.sessions)
          .child(courseId)
          .child(sessionId)
          .remove();
      setState(() {
        modles.removeAt(index);
      });
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  void attendanceTapped(int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return Instructor_Attendance(
            courseId: modles[index].courseid,
            sessionId: modles[index].sessionId);
      },
    ));
  }
}
