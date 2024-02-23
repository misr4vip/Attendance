import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Consts.dart';

class Utilies {
  Widget addTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }

  Widget addTextField(
    TextEditingController controller,
    String title,
    Function() action, {
    TextInputType inputType = TextInputType.text,
    bool obsureText = false,
    bool enableSuggestion = true,
    bool autoCorrect = true,
    bool readOnly = false,
    bool showCursor = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obsureText,
        enableSuggestions: enableSuggestion,
        autocorrect: autoCorrect,
        keyboardType: inputType,
        readOnly: readOnly,
        showCursor: showCursor,
        controller: controller,
        onTap: action,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(title),
        ),
      ),
    );
  }

  Widget addButton(String title, VoidCallback action) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.blue,
        border: Border.all(
          color: Color.fromARGB(255, 57, 137, 199),
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: TextButton(
        onPressed: action,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

showAlertDialog(
    BuildContext context, String message, VoidCallback onOKPressed) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: onOKPressed,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      constants.appName,
      style: TextStyle(
        color: Colors.black87,
        fontFamily: "Philosopher",
      ),
    ),
    content: Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white,
        ),
        child: Container(child: alert),
      );
    },
  );
}

showAlertDialogWithCancel(
    BuildContext context, String message, VoidCallback onOKPressed) {
  var buttonStyleOK = TextStyle(
    color: Colors.blue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  var buttonStyleCancel = TextStyle(
    color: Colors.blue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // set up the button
  Widget okButton = TextButton(
    child: Text(
      "OK",
      style: buttonStyleOK,
    ),
    onPressed: onOKPressed,
  );
  Widget cancelButton = TextButton(
    child: Text(
      "Cancel",
      style: buttonStyleCancel,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    insetPadding: EdgeInsets.all(0),
    title: Text(
      constants.appName,
      style: TextStyle(
        color: Colors.black87,
        fontFamily: "Philosopher",
      ),
    ),
    content: Text(
      message,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
    actions: [
      okButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.white,
        ),
        child: Container(child: alert),
      );
    },
  );
}

showCustomToast(String message, [Color? mColor]) {
  mColor ??= Color.fromARGB(153, 26, 20, 219);
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 16.0,
    textColor: Colors.white,
  );
}
