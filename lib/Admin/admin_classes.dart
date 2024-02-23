import 'package:attendance/Drawer/NavigationBottomBar/navigation.dart';
import 'package:attendance/Modles/classModel.dart';
import 'package:attendance/Modles/semster.dart';
import 'package:attendance/Admin/admin_add_class.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Drawer/MyDrawer.dart';
import '../Utils/Consts.dart';

class AdminClasses extends StatefulWidget {
  AdminClasses(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;
  @override
  State<AdminClasses> createState() =>
      _AdminClasses(userName, userEmail, usertype);
}

class _AdminClasses extends State<AdminClasses> {
  var modles = [ClassModel.m()];

  _AdminClasses(String userName, String userEmail, String userType) {
    userEmail = userEmail;
    userName = userName;
    userType = userType;
  }

  var userName = "";
  var userEmail = "";
  var userType = "";

  @override
  void initState() {
    // getUserData();
    modles.clear();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyNavigationBottomBar navi =
        MyNavigationBottomBar(context, userName, userType, userEmail);
    int currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Classes"),
      ),
      // drawer: Drawer(
      //   child:
      //       MyDrawer().adminDrawer(context, _userName, _userEmail, _usertype),
      // ),
      bottomNavigationBar: navi.adminWidget(currentIndex, (p0) {
        navi.onAdminNavigationItemTapped(p0);
        setState(() {
          currentIndex = p0;
        });
      }),
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
                        " ${modles[index].className}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            removeClass(modles[index].id, index);
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
              builder: (context) => AddClass(
                userEmail: userEmail,
                userName: userName,
                usertype: userType,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ///  function to get semsters from database
  Future getData() async {
    try {
      modles.clear();
      var dataSnap =
          await FirebaseDatabase.instance.ref().child(constants.classes).get();
      if (dataSnap.exists) {
        for (var snapShot in dataSnap.children) {
          setState(() {
            var classesModel = ClassModel.z(snapShot.value as Map);
            modles.add(classesModel);
          });
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future removeClass(String id, int index) async {
    try {
      // modles.clear();
      await FirebaseDatabase.instance
          .ref()
          .child(constants.classes)
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
