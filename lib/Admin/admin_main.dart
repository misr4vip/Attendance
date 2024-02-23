import 'package:attendance/Admin/admin_add_semster.dart';
import 'package:attendance/Drawer/NavigationBottomBar/navigation.dart';
import 'package:attendance/Modles/semster.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Auth/signin.dart';
import 'package:attendance/Admin/admin_classes.dart';
import '../Utils/Consts.dart';

class AdminMainWidget extends StatefulWidget {
  AdminMainWidget(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.usertype})
      : super(key: key);
  String userName;
  String userEmail;
  String usertype;
  @override
  State<AdminMainWidget> createState() =>
      _AdminMainWidget(userName, userEmail, usertype);
}

class _AdminMainWidget extends State<AdminMainWidget> {
  var modles = [SemsterModel.m()];

  _AdminMainWidget(String userName, String userEmail, String userType) {
    userEmail = userEmail;
    userName = userName;
    userType = userType;
  }

  int currentIndex = 0;
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Main"),
      ),
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
                        " ${modles[index].semster} - ${modles[index].year}   Active:  ",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Icon(modles[index].isActive ? Icons.done : Icons.close),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            removeSemster(modles[index].id, index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.blue,
                            size: 22,
                          )),
                      modles[index].isActive
                          ? Text("")
                          : ElevatedButton(
                              onPressed: () {
                                activate_Semster(index, modles[index].id);
                              },
                              child: const Text("Activate")),
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
              builder: (context) => AddSemster(
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
          await FirebaseDatabase.instance.ref().child(constants.semster).get();
      if (dataSnap.exists) {
        for (var snapShot in dataSnap.children) {
          setState(() {
            var semsterModel = SemsterModel.z(snapShot.value as Map);
            modles.add(semsterModel);
          });
        }
      }
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future removeSemster(String id, int index) async {
    try {
      // modles.clear();
      await FirebaseDatabase.instance
          .ref()
          .child(constants.semster)
          .child(id)
          .remove();
      setState(() {
        modles.removeAt(index);
      });
    } on FirebaseException catch (e) {
      showCustomToast(e.message!);
    }
  }

  Future activate_Semster(int index, String id) async {
    setState(() {
      modles[index].isActive = true;
    });

    for (var model in modles) {
      if (model.id == id) {
        await FirebaseDatabase.instance
            .ref()
            .child(constants.semster)
            .child(model.id)
            .update({"isActive": true});
      }
      if (model.isActive && model.id != id) {
        setState(() {
          model.isActive = false;
        });

        await FirebaseDatabase.instance
            .ref()
            .child(constants.semster)
            .child(model.id)
            .update({"isActive": false});
      }
    }
  }
}
