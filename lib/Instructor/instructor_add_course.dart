import 'package:attendance/Instructor/instructor_courses.dart';
import 'package:attendance/Modles/classModel.dart';
import 'package:attendance/Modles/course_model.dart';
import 'package:attendance/Modles/semster.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Utils/Consts.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

// ignore: camel_case_types
class instructorAddCourse extends StatefulWidget {
  const instructorAddCourse({Key? key}) : super(key: key);

  @override
  State<instructorAddCourse> createState() => _instructorAddCourseState();
}

class _instructorAddCourseState extends State<instructorAddCourse> {
  Utilies util = Utilies();
  TextEditingController courseNameController = TextEditingController();
  TextEditingController semsterController = TextEditingController();
  TextEditingController classController = TextEditingController();
  var myModel = SemsterModel.m();
  var itemsList = <DropdownMenuEntry<String>>[];
  String selectedValue = "class name";
  @override
  Widget build(BuildContext context) {
    getActiveSemster();

    semsterController.text =
        "${myModel.semster} - ${myModel.year}   (Active Semster)";
    getClasses();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            util.addTitle("Add New Course"),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: DropdownMenu(
                width: MediaQuery.of(context).size.width - 40,
                enableSearch: false,
                controller: classController,
                enableFilter: false,
                label: Text(selectedValue),
                onSelected: (newValue) {
                  setState(() {
                    if (newValue == null) {
                      selectedValue = "none";
                    } else {
                      selectedValue = newValue as String;
                    }
                  });
                },
                dropdownMenuEntries: itemsList,
              ),
            ),
            util.addTextField(semsterController, "semster", () {},
                readOnly: true),
            util.addTextField(courseNameController, "course name", () {}),
            util.addButton("Add", () {
              addCourse();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const instructor_courses()));
            })
          ],
        ),
      ),
    );
  }

  Future getActiveSemster() async {
    try {
      var data =
          await FirebaseDatabase.instance.ref().child(constants.semster).get();
      if (data.exists) {
        for (var value in data.children) {
          var model = SemsterModel.z(value.value as Map);
          if (model.isActive) {
            setState(() {
              myModel = model;
            });

            break;
          }
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future getClasses() async {
    try {
      var data =
          await FirebaseDatabase.instance.ref().child(constants.classes).get();
      if (data.exists) {
        itemsList.clear();
        for (var value in data.children) {
          var model = ClassModel.z(value.value as Map);
          itemsList.add(DropdownMenuEntry<String>(
            value: model.id,
            label: model.className,
            leadingIcon: Icon(Icons.book),
          ));
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future addCourse() async {
    if (courseNameController.text.isEmpty || selectedValue == "class name") {
      showCustomToast("invalid course name or class name");
    } else {
      var doctorId = FirebaseAuth.instance.currentUser!.uid;
      var courseId = Uuid().v1().toString();
      var courseModel = CourseModel.n(courseId, courseNameController.text,
          doctorId, myModel.id, selectedValue);
      FirebaseDatabase.instance
          .ref()
          .child(constants.courses)
          .child(courseId)
          .set(courseModel.toDictionary());
      showCustomToast("course Added Successfully");
    }
  }
}
