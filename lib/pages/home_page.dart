import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/auth_page/Login_page.dart';
import 'package:chat_app/pages/profile_Page.dart';

import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String? username = "";
  String? email = "";
  Stream? groups;

  @override
  void initState() {
    getingUserData();
    super.initState();
  }

  void getingUserData() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        username = value;
      });
    });
    await HelperFunction.getUserEmailSF().then((value) {
      setState(() {
        email = value;
      });
    });
//Getting list of snapshot in the stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: 80,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                username!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                nextScreen(context, const ProfilePage());
              },
              child: Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(
                    width: 12,
                  ),
                  Text("Profile")
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                authService.signOut().whenComplete(() {
                  nextScreen(context, const LoginPage());
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 12,
                  ),
                  Text("Log out")
                ],
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          popUpDialog(context);
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  void popUpDialog(BuildContext context) {}
  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              return const Text("Hello");
            } else {
              return const Center(
                child: Text("You have no Groups"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
