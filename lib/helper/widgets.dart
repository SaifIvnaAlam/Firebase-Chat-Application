import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: ((context) => page),
    ),
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: ((context) => page),
    ),
  );
}

void showSnackbar(context, color, massage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(massage),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label: "Gotcha", onPressed: () {}),
  ));
}
