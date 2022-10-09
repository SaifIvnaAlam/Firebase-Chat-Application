import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
//UpDate user data

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
//UpDate user data
  Future updateUserData(
    String fullName,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }
}
