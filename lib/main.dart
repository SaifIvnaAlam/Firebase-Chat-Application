import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/pages/auth_page/Login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSingedin = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatud().then((value) {
      if (value != null) {
        setState(() {
          _isSingedin = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isSingedin ? const HomePage() : const LoginPage(),
    );
  }
}
