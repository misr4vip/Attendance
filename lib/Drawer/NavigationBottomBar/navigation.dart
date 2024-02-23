import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendance/Auth/signin.dart';
import 'package:attendance/Admin/admin_classes.dart';
import 'package:attendance/Admin/admin_main.dart';

class MyNavigationBottomBar {
  MyNavigationBottomBar(
      this.mContext, this.userName, this.userType, this.userEmail);
  BuildContext mContext;
  String userName;
  String userType;
  String userEmail;
  Widget adminWidget(int pIndex, Function(int) callBack) {
    return BottomNavigationBar(
        currentIndex: pIndex,
        onTap: (index) {
          setState() {
            pIndex = index;
          }

          callBack(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_sharp),
            tooltip: "Main",
            label: "Main",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_rounded),
            tooltip: "classes",
            label: "classes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            tooltip: "Sign Out",
            label: "Sign out",
          )
        ]);
  }

  void onAdminNavigationItemTapped(int index) {
    if (index == 0) {
      Navigator.of(mContext).push(MaterialPageRoute(
          builder: (mContext) => AdminMainWidget(
                userEmail: userEmail,
                userName: userName,
                usertype: userType,
              )));
    } else if (index == 1) {
      Navigator.of(mContext).push(MaterialPageRoute(
          builder: (mContext) => AdminClasses(
                userEmail: userEmail,
                userName: userName,
                usertype: userType,
              )));
    } else {
      FirebaseAuth.instance.signOut();
      Navigator.of(mContext).push(MaterialPageRoute(builder: (mContext) {
        return const SignInWidget();
      }));
    }
  }
}
