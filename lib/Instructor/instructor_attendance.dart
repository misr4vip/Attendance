import 'package:attendance/Modles/studentAttendanceModel.dart';
import 'package:attendance/Modles/userModel.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Instructor_Attendance extends StatefulWidget {
  Instructor_Attendance(
      {Key? key, required this.courseId, required this.sessionId})
      : super(key: key);

  String courseId = "", sessionId = "";
  @override
  State<Instructor_Attendance> createState() =>
      _Instructor_AttendanceState(courseId, sessionId);
}

class _Instructor_AttendanceState extends State<Instructor_Attendance> {
  String courseId, sessionId;
  var modles = [StudentAttendanceModel.m()];
  var studentsList = [UserModel.m()];

  @override
  void initState() {
    modles.clear();
    studentsList.clear();
    getData();
    super.initState();
  }

  _Instructor_AttendanceState(this.courseId, this.sessionId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () {
            exportDataToExcel();
          },
        )
      ]),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " student:  ${studentsList[index].name}   ",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Text(
                        "  status: ${modles[index].status}  ",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      modles[index].status == "onTime"
                          ? Text(" ")
                          : Text(
                              "    late for: ${modles[index].lateTime} minute",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
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
    );
  }

  Future getData() async {
    final data = await FirebaseDatabase.instance
        .ref()
        .child(constants.studentAttendance)
        .child(courseId)
        .child(sessionId)
        .get();
    if (data.exists) {
      for (var snap in data.children) {
        final studentAttendance = StudentAttendanceModel.z(snap.value as Map);

        final studentData = await FirebaseDatabase.instance
            .ref()
            .child(constants.users)
            .child(studentAttendance.studentId)
            .get();
        late UserModel student;
        if (studentData.exists) {
          student = UserModel.z(studentData.value as Map);
        }
        setState(() {
          modles.add(studentAttendance);
          studentsList.add(student);
        });
      }
    }
  }

  Future exportDataToExcel() async {
    if (modles.isNotEmpty) {
      var myExcel = excel.Excel.createExcel();
      var sheet = myExcel['Attendance'];
      sheet.appendRow(['student name', 'status', 'late in minute']);
      for (int i = 0; i < modles.length; i++) {
        sheet.appendRow(
            [studentsList[i].name, modles[i].status, modles[i].lateTime]);
      }
      var fileBytes = myExcel.save();
      Directory directory = await getExternalStorageDirectory() as Directory;

      String appDocumentsPath = directory.path;
      appDocumentsPath = appDocumentsPath.substring(0,19);
      appDocumentsPath += "/Download";
      print("path : ${appDocumentsPath}");
      File(join(
          '$appDocumentsPath/attendance_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      showCustomToast("file exported successfully");
    } else {
      showCustomToast("sorry there is no record to export.");
    }
  }
}
