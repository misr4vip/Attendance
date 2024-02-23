import 'package:attendance/Admin/admin_main.dart';
import 'package:attendance/Modles/semster.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../Utils/Consts.dart';

class AddSemster extends StatefulWidget {
  AddSemster(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;

  @override
  State<AddSemster> createState() => _AddSemsterState(
      userName: userName, userEmail: userEmail, usertype: usertype);
}

class _AddSemsterState extends State<AddSemster> {
  _AddSemsterState(
      {required this.userName,
      required this.userEmail,
      required this.usertype});

  final String userName;
  final String userEmail;
  final String usertype;
  final _semsterController = TextEditingController();
  final _yearController = TextEditingController();
  var modles = [SemsterModel.m()];
  Utilies u = Utilies();
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            u.addTitle("New Semster"),
            const SizedBox(
              height: 50,
            ),
            u.addTextField(
                _semsterController, "Semster ex first , second", () {}),
            u.addTextField(_yearController, "year ex 2023", () {}),
            Row(
              children: [
                Text(
                  "is The Active Semster?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "yes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Radio(
                    value: true,
                    groupValue: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value as bool;
                      });
                    }),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "no",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Radio(
                    value: false,
                    groupValue: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value as bool;
                      });
                    }),
              ],
            ),
            u.addButton("Save", () {
              addSemsterFunc();
            })
          ],
        ),
      ),
    );
  }

  /// dart function to retrive admin semster input and store it in database
  Future addSemsterFunc() async {
    try {
      //  to genrate an unique key
      var id = const Uuid().v1();
      var semsterModel = SemsterModel.n(id, _semsterController.text.toString(),
          _yearController.text.toString(), isActive);
      if (isActive) {
        modles.clear();
        var semsterRef = await FirebaseDatabase.instance
            .ref()
            .child(constants.semster)
            .get();
        if (semsterRef.exists) {
          for (var dataSnap in semsterRef.children) {
            var semsterModel = SemsterModel.z(dataSnap.value as Map);
            modles.add(semsterModel);
          }
          for (SemsterModel model in modles) {
            model.isActive = false;
          }
        }

        modles.add(semsterModel);
        for (var model in modles) {
          await FirebaseDatabase.instance
              .ref()
              .child(constants.semster)
              .child(model.id)
              .set(model.toDictionary());
        }
      } else {
        await FirebaseDatabase.instance
            .ref()
            .child(constants.semster)
            .child(semsterModel.id)
            .set(semsterModel.toDictionary());
      }

      showCustomToast("Semster Added Successfully");

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdminMainWidget(
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
