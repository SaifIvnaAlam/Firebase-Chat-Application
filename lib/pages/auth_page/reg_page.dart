import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/auth_page/Login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
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
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
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
                                },
                              );
                            },
                            validator: (value) {
                              return value!.isNotEmpty
                                  ? null
                                  : "Name Can not Be empty";
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
                              register();
                            },
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
                ),
              ));
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLoggedInStatus(true);

          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUsernameSF(fullName);
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
