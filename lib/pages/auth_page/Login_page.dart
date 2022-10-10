import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/auth_page/reg_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                          onPressed: () {
                            logIn();
                          },
                          child: const Text("Log in"),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            nextScreen(context, const RegisterPage());
                          },
                          child: const Text("register now"),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }

  logIn() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .logInWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunction.saveUserLoggedInStatus(true);

          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUsernameSF(
            snapshot.docs[0]['fullName'],
          );

          nextScreenReplace(context, const HomePage());
        } else {
          setState(() {
            showSnackbar(context, Colors.red, value.toString());
            _isLoading = false;
          });
        }
      });
    }
  }
}
