import 'package:attendance/Admin/admin_classes.dart';
import 'package:attendance/Admin/admin_main.dart';
import 'package:attendance/Instructor/instructor_add_course.dart';
import 'package:attendance/Instructor/instructor_courses.dart';
import 'package:attendance/Student/studentAvilableCourses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Auth/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Utils/Consts.dart';
import 'Utils/Utils.dart';
import 'firebase_options.dart';
import 'Instructor/instructor_attendance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static const String _title = 'Attendance';
  static bool isLogin = false;
  var userName = "";
  var userEmail = "";
  var usertype = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      routes: {
        "adminMain": (context) => AdminMainWidget(
            userName: userName, userEmail: userEmail, usertype: usertype),
        "adminClasses": (context) => AdminClasses(
            userName: userName, userEmail: userEmail, usertype: usertype),
        "instructorAddCourse": (context) => instructorAddCourse(),
      },
      home: Container(
          //  appBar: AppBar(title: const Text(_title)),
          child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser != null) {
              getUserType(context);
            }
          }
          return const SignInWidget();
        },
      )),
    );
  }

  Future getUserType(BuildContext context) async {
    try {
      var id = FirebaseAuth.instance.currentUser!.uid;
      var data = await FirebaseDatabase.instance
          .ref()
          .child(constants.users)
          .child(id)
          .get();
      if (data.exists) {
        var dataValue = data.value as Map;
        userEmail = dataValue['email'] as String;
        userName = dataValue['name'] as String;
        usertype = dataValue['userType'] as String;
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }

    if (usertype == "Instructor") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return instructor_courses();
      }));
    } else if (usertype == "Admin") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return AdminMainWidget(
          userName: userName,
          userEmail: userEmail,
          usertype: usertype,
        );
      }));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return StudentAvilableCourses(
          userName: userName,
          userEmail: userEmail,
          usertype: usertype,
        );
      }));
    }
  }
}
