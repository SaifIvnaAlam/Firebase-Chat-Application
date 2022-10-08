import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Email"),
              onChanged: (value) {
                setState(
                  () {
                    email = value;
                    print(email);
                  },
                );
              },
              validator: (value) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)
                    ? null
                    : "Please Enter a valid Email";
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
              onChanged: (value) {
                setState(
                  () {
                    password = value;
                    print(password);
                  },
                );
              },
              validator: (value) {
                if (value!.length < 6) {
                  return "Password Must be at least 6";
                } else {
                  return null;
                }
              },
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {},
              child: const Text("Log in"),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {},
              child: const Text("register now"),
            )
          ],
        ),
      ),
    ));
  }

  logIn() {}
}
