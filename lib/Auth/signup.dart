import 'package:attendance/Instructor/instructor_attendance.dart';
import 'package:attendance/Auth/signin.dart';
import 'package:attendance/Instructor/instructor_courses.dart';
import 'package:attendance/Student/studentAvilableCourses.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:attendance/Utils/Utils.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidget();
}

class _SignUpWidget extends State<SignUpWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String dropdownvalue = 'Account type';
  Utilies u = Utilies();
  var items = ['Account type', 'Student', 'Instructor'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign Up"),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            //    color: Color.fromARGB(255, 242, 237, 237),
            padding: EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black26,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.circular(10),
              hint: Text(dropdownvalue),
              value: dropdownvalue,
              itemHeight: 70,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
          u.addTextField(nameController, "Name", () {}),
          u.addTextField(emailController, "Email", () {}),
          u.addTextField(passwordController, "Password", () {},
              obsureText: true),
          u.addButton("Sign Up", signUp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('have an account?'),
              TextButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignInWidget(),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      )),
    );
  }

  Future signUp() async {
    final dialog = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
                child: Column(
              children: [
                Spacer(),
                CircularProgressIndicator(),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            )));
    try {
      if (dropdownvalue == "Student" || dropdownvalue == "Instructor") {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.toString(),
                password: passwordController.text.toString());

        final id = credential.user!.uid;
        FirebaseDatabase.instance.ref().child("users").child(id).set({
          'name': nameController.text,
          'userType': dropdownvalue,
          'email': emailController.text,
          'password': passwordController.text,
          'id': id
        });
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop(dialog);
        if (dropdownvalue == "Student") {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return StudentAvilableCourses(
              userName: nameController.text,
              userEmail: emailController.text,
              usertype: dropdownvalue,
            );
          }));
        } else if (dropdownvalue == "Instructor") {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return instructor_courses();
          }));
        }
      } else {
        showCustomToast('chose Account type.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showCustomToast('The account already exists for that email.');
      }
    } catch (e) {
      showCustomToast(e.toString());
    }
  }
}
