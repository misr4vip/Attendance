import 'package:attendance/Auth/signin.dart';
import 'package:attendance/Instructor/instructor_add_course.dart';
import 'package:attendance/Instructor/instructor_sessions.dart';
import 'package:attendance/Modles/course_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:attendance/Utils/Utils.dart';

class instructor_courses extends StatefulWidget {
  instructor_courses({Key? key}) : super(key: key);

  @override
  State<instructor_courses> createState() => _instructor_coursesState();
}

class _instructor_coursesState extends State<instructor_courses> {
  var modles = [CourseModel.m()];

  @override
  void initState() {
    modles.clear();
    getData();
    super.initState();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("courses"),
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
              tooltip: "My Courses",
              label: "My Courses",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              tooltip: "Sign out",
              label: "Sign out",
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
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => instructor_sessions(
                                    courseId: modles[index].courseid,
                                    courseName: modles[index].courseName)));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red;
                              }
                              return Colors.deepOrange;
                            }),
                          ),
                          child: Text("sessions")),
                      IconButton(
                          onPressed: () {
                            //  removeSemster(modles[index].id, index);
                            removeCouser(modles[index].courseid, index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.blue,
                            size: 22,
                          )),
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
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const instructorAddCourse()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onNavigationItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return instructor_courses();
      }));
    } else {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const SignInWidget();
      }));
    }
  }

  ///  function to get courses from database
  Future getData() async {
    try {
      modles.clear();
      var dataSnap =
          await FirebaseDatabase.instance.ref().child(constants.courses).get();
      if (dataSnap.exists) {
        for (var snapShot in dataSnap.children) {
          setState(() {
            var doctorId = FirebaseAuth.instance.currentUser!.uid;
            var courseModel = CourseModel.z(snapShot.value as Map);
            if (courseModel.doctorId == doctorId) {
              modles.add(courseModel);
            }
          });
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future removeCouser(String id, int index) async {
    try {
      // modles.clear();
      await FirebaseDatabase.instance
          .ref()
          .child(constants.courses)
          .child(id)
          .remove();
      setState(() {
        modles.removeAt(index);
      });
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }
}
