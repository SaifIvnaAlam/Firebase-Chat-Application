import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/auth_page/Login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = '';
  String password = '';
  String fullName = '';
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      fullName = value;
                      print(fullName);
                    },
                  );
                },
                validator: (value) {
                  return value!.isNotEmpty ? null : "Name Can not Be empty";
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
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
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
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
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: () {},
                child: const Text("Register now"),
              ),
              TextButton(
                  onPressed: () {
                    nextScreen(context, const LoginPage());
                  },
                  child: const Text("Log in now"))
            ],
          ),
        ),
      ),
    ));
  }
}
