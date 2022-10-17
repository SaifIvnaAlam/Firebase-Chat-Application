import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupName;
  final String adminName;
  final String groupId;
  const GroupInfoPage(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

//Getting the list of Members
  Future getMembers() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
      print(members);
    });
  }

  //admin name
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.groupName),
            Text(getName(widget.adminName)),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              var ax = snapshot.data['members'] as List;
              int bx = ax.length;
              if (bx != 0) {
                // return ListView.builder(
                //   itemCount: bx,
                //   itemBuilder: (BuildContext context, int index) {
                //     return ListTile(
                //         title: Text(getName(snapshot.data["memebers"][index])));
                //   },
                // );
                return Text("Jamela nai");
              } else {
                return Text("jamela ase");
              }
            } else {
              return Text("it is null");
            }
          } else {
            return const Center(child: Text("No members found"));
          }
        });
  }
}
