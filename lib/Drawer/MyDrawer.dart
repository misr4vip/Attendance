import 'package:attendance/Instructor/instructor_courses.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth/signin.dart';
import 'package:attendance/Admin/admin_main.dart';
import 'package:attendance/Admin/admin_classes.dart';

class MyDrawer {
  Widget adminDrawer(BuildContext context, String userName, String userEmail,
      String userType) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                Text(
                  userType,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text('Main'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminMainWidget(
                      userEmail: userEmail,
                      userName: userName,
                      usertype: userType,
                    )));
          },
        ),
        ListTile(
          title: const Text('classes'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminClasses(
                      userEmail: userEmail,
                      userName: userName,
                      usertype: userType,
                    )));
          },
        ),
        ListTile(
          title: const Text('Sign Out'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignInWidget()));
          },
        ),
      ],
    );
  }

  Widget instructorDrawer(BuildContext context, String userName,
      String userEmail, String userType) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                Text(
                  userType,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Row(
            children: [
              Icon(Icons.book),
              SizedBox(width: 10),
              Text('Courses'),
            ],
          ),
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => const instructor_courses()));
          },
        ),
        ListTile(
          title: const Text('Sessions'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Sign Out'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignInWidget()));
          },
        ),
      ],
    );
  }
}
