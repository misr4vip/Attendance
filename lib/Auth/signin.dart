import 'package:attendance/Auth/signup.dart';
import 'package:attendance/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidget();
}

class _SignInWidget extends State<SignInWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Utilies u = Utilies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            u.addTextField(nameController, "Email", () {}),
            u.addTextField(passwordController, "Password", () {},
                obsureText: true, autoCorrect: false, enableSuggestion: false),
            TextButton(
              onPressed: () {
                //forgot password screen
                showCustomToast('forget password tapped');
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            u.addButton("Login", signIn),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have an account?'),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpWidget(),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showCustomToast('Wrong password provided for that user.');
      }
    }
  }
}
