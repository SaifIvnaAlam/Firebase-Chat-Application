import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/auth_page/Login_page.dart';
import 'package:chat_app/pages/profile_Page.dart';

import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
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
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String groupName = "";
  @override
  void initState() {
    getingUserData();
    super.initState();
  }

  //string manipulation to get group id and name
  String getgroupId(String res) {
    var text = res.substring(0, res.indexOf("_"));

    var text2 = text.split("(groups/").last;
    var text3 = text2.substring(0, text2.indexOf(")"));
    return text3;
  }

  //string manipulation to get group id and name
  String getGroupName(String res) {
    return res.substring(res.indexOf("_") + 1);
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
      print(snapshot);
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

  void popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            //todo: call the database to create groups

            title: const Text("Create Group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextField(
                        onChanged: ((value) {
                          groupName = value;
                        }),
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Group Name",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      )
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                username!,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackbar(context, Colors.green,
                            "Group Created Successfully");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.pink,
                        fixedSize: const Size(100, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: const Text('Create'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        fixedSize: const Size(100, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: const Text('Cancle'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var ax = snapshot.data;
            int bx = ax['groups'].length;
            if (ax['groups'] != null) {
              if (bx != 0) {
                print(getgroupId(ax["groups"][0]));

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: bx,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return GroupTile(
                          groupid: getgroupId(ax["groups"][index]),
                          groupname: getGroupName(ax['groups'][index]),
                          username: ax['fullName']);
                    });
              } else {
                return const Center(
                  child: Text("You have no Groups"),
                );
              }
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
