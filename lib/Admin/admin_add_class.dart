import 'package:attendance/Admin/admin_classes.dart';
import 'package:attendance/Modles/classModel.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../Utils/Consts.dart';

class AddClass extends StatefulWidget {
  AddClass(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;

  @override
  State<AddClass> createState() => _AddClassState(
      userName: userName, userEmail: userEmail, usertype: usertype);
}

class _AddClassState extends State<AddClass> {
  _AddClassState(
      {required this.userName,
      required this.userEmail,
      required this.usertype});

  final String userName;
  final String userEmail;
  final String usertype;
  final _classNameController = TextEditingController();
  final _firstPointController = TextEditingController();
  final _secondPointController = TextEditingController();
  final _thirdPointController = TextEditingController();
  final _fourthPointController = TextEditingController();
  var modles = [ClassModel.m()];
  Utilies u = Utilies();
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            u.addTitle("New Class"),
            const SizedBox(
              height: 50,
            ),
            u.addTextField(_classNameController, "class name", () {}),
            const Text(
              "latitude,longitude ex 23.423434343,25.2345432",
              style: TextStyle(
                color: Colors.black12,
              ),
            ),
            u.addTextField(_firstPointController, "first point ", () {}),
            u.addButton("Save", () {
              addClassFunc();
            })
          ],
        ),
      ),
    );
  }

  /// dart function to retrive admin semster input and store it in database
  Future addClassFunc() async {
    try {
      //  to genrate an unique key
      var id = const Uuid().v1();
      var classModel = ClassModel.n(
        id,
        _classNameController.text.toString(),
        _firstPointController.text.toString(),
      );

      await FirebaseDatabase.instance
          .ref()
          .child(constants.classes)
          .child(classModel.id)
          .set(classModel.toDictionary());

      showCustomToast("class Added Successfully");

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdminClasses(
              userName: userName,
              usertype: usertype,
              userEmail: userEmail,
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.code);
    } catch (e) {
      showCustomToast(e.toString());
    }
  }
}
