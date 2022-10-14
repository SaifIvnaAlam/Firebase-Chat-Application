import 'package:flutter/material.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupName;
  final String adminName;
  const GroupInfoPage(
      {Key? key, required this.adminName, required this.groupName})
      : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.adminName),
      ),
    );
  }
}
