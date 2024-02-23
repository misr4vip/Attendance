import 'package:attendance/Auth/signin.dart';
import 'package:attendance/Modles/userModel.dart';
import 'package:attendance/Student/studentAvilableCourses.dart';
import 'package:attendance/Student/studentCourseSessions.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:attendance/Modles/course_model.dart';

import 'package:attendance/Modles/semster.dart';

class StudentCourses extends StatefulWidget {
  StudentCourses(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;

  String getUserName() {
    return this.userName;
  }

  @override
  State<StudentCourses> createState() =>
      _StudentCourses(userName, usertype, userEmail);
}

class _StudentCourses extends State<StudentCourses> {
  @override
  void initState() {
    modles.clear();
    getAllCourses();
    super.initState();
  }

  int _currentIndex = 1;
  var modles = [CourseModel.m()];
  var regCoursesIds = <String>[];
  var doctorModles = [UserModel.m()];
  String userName = "", userEmail = "", userType = "";
  _StudentCourses(this.userName, this.userEmail, this.userType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Student Main"),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              onNavigationItemTapped(index);
            },
            iconSize: 20,
            unselectedFontSize: 10,
            selectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book_sharp),
                tooltip: "Avilable Courses",
                label: "Avilable Courses",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online_rounded),
                tooltip: "My Courses",
                label: "My Courses",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                tooltip: "Sign out",
                label: "Sign out",
              )
            ]),
        body: ListView.builder(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.book_online_rounded,
                        color: Colors.blueGrey,
                        size: 34,
                      ),
                      Text(
                        " ${modles[index].courseName.toUpperCase()}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            goToSession(index);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red;
                              }
                              return Color.fromARGB(255, 28, 137, 192);
                            }),
                          ),
                          child: const Text("Sessions")),
                    ],
                  ),
                  Text(
                    "doctor: ${doctorModles[index].name}",
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            );
          },
        ));
  }

  void onNavigationItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return StudentAvilableCourses(
          userEmail: userEmail,
          userName: userName,
          usertype: userType,
        );
      }));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return StudentCourses(
          userEmail: userEmail,
          userName: userName,
          usertype: userType,
        );
      }));
    } else {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const SignInWidget();
      }));
    }
  }

  void goToSession(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return StudentCourseSession(
          userName: userName,
          userEmail: userEmail,
          usertype: userType,
          courseModel: modles[index]);
    }));
  }

  Future getAllCourses() async {
    try {
      modles.clear();
      doctorModles.clear();
      String? studentId = FirebaseAuth.instance.currentUser?.uid;
      ///// get active semster
      var semsterId = "";
      var semsterData =
          await FirebaseDatabase.instance.ref().child(constants.semster).get();
      if (semsterData.exists) {
        for (var snap in semsterData.children) {
          var semster = SemsterModel.z(snap.value as Map);
          if (semster.isActive) {
            semsterId = semster.id;
            break;
          }
        }
      }

      /// get registed courses
      var data = await FirebaseDatabase.instance
          .ref()
          .child(constants.studentCourses)
          .child(studentId!)
          .get();
      if (data.exists) {
        for (var snap in data.children) {
          var courseId = snap.key;
          regCoursesIds.add(courseId!);
        }
      }

      /// get all courses from database
      var dataSnap =
          await FirebaseDatabase.instance.ref().child(constants.courses).get();
      if (dataSnap.exists) {
        for (var snapShot in dataSnap.children) {
          var courseModel = CourseModel.z(snapShot.value as Map);
          if (courseModel.semsterId == semsterId) {
            if (regCoursesIds.contains(courseModel.courseid)) {
              var doctordata = await FirebaseDatabase.instance
                  .ref()
                  .child(constants.users)
                  .child(courseModel.doctorId)
                  .get();
              if (doctordata.exists) {
                UserModel doctorModel = UserModel.z(doctordata.value as Map);
                doctorModles.add(doctorModel);
              }
              setState(() {
                modles.add(courseModel);
              });
            }
          }
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }
}
