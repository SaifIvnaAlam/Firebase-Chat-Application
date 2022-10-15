import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/group_infor_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;

  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfoPage(
                      adminName: admin,
                      groupName: widget.groupName,
                      groupId: widget.groupId,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Center(),
    );
  }
}
