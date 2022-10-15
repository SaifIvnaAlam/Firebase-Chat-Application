import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
//UpDate user data

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
//saving user data
  Future savingUserData(
    String fullname,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  //Geting user data from database to find if the use exists
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

//get user group
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

//Creating Group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupCollection.add({
      "GroupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "rececntMessage": "",
      "recentMessageSender": "",
    });
//update group information after group has been created
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupdocumentReference.id
    });

    //update group list in usercollection
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupdocumentReference}_$groupName"])
    });
  }

  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
//get Group members

  Future getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }
}
