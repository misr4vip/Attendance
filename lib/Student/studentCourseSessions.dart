import 'package:attendance/Modles/classModel.dart';
import 'package:attendance/Modles/session_model.dart';
import 'package:attendance/Modles/studentAttendanceModel.dart';
import 'package:attendance/Modles/userModel.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:attendance/Utils/my_date.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:attendance/Modles/course_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class StudentCourseSession extends StatefulWidget {
  StudentCourseSession(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype,
      required this.courseModel})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;
  var courseModel = CourseModel.m();

  String getUserName() {
    return this.userName;
  }

  @override
  State<StudentCourseSession> createState() =>
      _StudentCourseSession(userName, usertype, userEmail, courseModel);
  // _StudentCourseSession();
}

class _StudentCourseSession extends State<StudentCourseSession> {
  @override
  void initState() {
    modles.clear();
    getAllSessions(courseModel.courseid);

    super.initState();
  }

  var studentId = FirebaseAuth.instance.currentUser!.uid;
  String? _currentAddress;
  Position? _currentPosition;
  var courseModel = CourseModel.m();
  var modles = [SessionModel.m()];
  var regCoursesIds = <String>[];
  var doctorModles = [UserModel.m()];
  String userName = "", userEmail = "", userType = "";
  MyDate date = MyDate();
  late DateTime sessionStartDateTime, myDateTime;
  _StudentCourseSession(
      this.userName, this.userEmail, this.userType, this.courseModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${courseModel.courseName} sessions"),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: modles.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width - 40,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "date : ${modles[index].sessionDate}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 116, 199)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "start time : ${modles[index].sessionStartTime}  /  end time : ${modles[index].sessionEndtime}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 14, 116, 199)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  checkIfSameDate(index)
                      ? ElevatedButton(
                          onPressed: () {
                            _getCurrentPosition().then((value) {
                              checkIfSessionRecorded(index).then((value) {
                                if (value) {
                                  showCustomToast(
                                      "attendance already recorded");
                                } else {
                                  checkIfStudentInside(index);
                                }
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red;
                              }
                              return const Color.fromARGB(255, 28, 137, 192);
                            }),
                          ),
                          child: const Text("attendance"))
                      : const Text(
                          " ",
                        ),
                ],
              ),
            );
          },
        ));
  }

  Future getAllSessions(String courseId) async {
    try {
      modles.clear();

      /// get registed courses
      var data = await FirebaseDatabase.instance
          .ref()
          .child(constants.sessions)
          .child(courseId)
          .get();
      if (data.exists) {
        for (var snap in data.children) {
          var session = SessionModel.z(snap.value as Map);
          setState(() {
            modles.add(session);
          });
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  bool checkIfSameDate(int index) {
    return date.compareDateTimeWithToday(modles[index].sessionDate,
        modles[index].sessionStartTime, modles[index].sessionEndtime);
  }

  Future<bool> checkIfSessionRecorded(int index) async {
    final data = await FirebaseDatabase.instance
        .ref()
        .child(constants.studentAttendance)
        .child(courseModel.courseid)
        .child(modles[index].sessionId)
        .child(studentId)
        .get();
    if (data.exists) {
      return Future.value(true);
    } else {
      return Future.value(false);
      ;
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future checkIfStudentInside(int index) async {
    ClassModel model = ClassModel.m();
    var data = await FirebaseDatabase.instance
        .ref()
        .child(constants.classes)
        .child(courseModel.classId)
        .get();
    if (data.exists) {
      model = ClassModel.z(data.value as Map);
    }
    int index1 = model.point1.indexOf(",");
    double p1Lat = double.parse(model.point1.substring(0, index1).trim());
    double p1Lon = double.parse(
        model.point1.substring(index1 + 1, model.point1.length).trim());

    var resultInMeter = await Geolocator.distanceBetween(
        p1Lat, p1Lon, _currentPosition!.latitude, _currentPosition!.longitude);
    sessionStartDateTime = date.convertStringDateToDateTime(
        modles[index].sessionDate, modles[index].sessionStartTime);
    myDateTime = DateTime.now();
    var time = myDateTime.difference(sessionStartDateTime);
    var id = Uuid().v1().toString();

    var status = time.inMinutes > 1 ? constants.late : constants.onTime;
    int lateTime = time.inMinutes;
    var stuAttendance = StudentAttendanceModel.n(studentId, status, lateTime);
    if (resultInMeter < 30) {
      var data = await FirebaseDatabase.instance
          .ref()
          .child(constants.studentAttendance)
          .child(courseModel.courseid)
          .child(modles[index].sessionId)
          .child(studentId)
          .set(stuAttendance.toDictionary())
          .whenComplete(
              () => showCustomToast("your attendance recorded successfully"))
          .onError((error, stackTrace) => showCustomToast(error.toString()));
    } else {
      showCustomToast("sorry you are outside class");
    }
  }
}
