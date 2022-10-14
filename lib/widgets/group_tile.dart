import 'package:chat_app/helper/widgets.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String username;
  final String groupname;
  final String groupid;

  const GroupTile({
    Key? key,
    required this.groupid,
    required this.groupname,
    required this.username,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          nextScreen(
              context,
              ChatPage(
                groupId: widget.groupid,
                groupName: widget.groupname,
                userName: widget.username,
              ));
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Text(
              widget.groupname.substring(0, 1).toUpperCase(),
            ),
          ),
          title: Text(widget.groupname.toUpperCase()),
          subtitle: Text("join as ${widget.username}"),
        ),
      ),
    );
  }
}
