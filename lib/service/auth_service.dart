import 'package:chat_app/helper/helper_fancttion.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //register user

  Future registerUserWithEmailAndPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await DatabaseService(uid: user.uid).savingUserData(fullname, email);
      return true;
    } on FirebaseAuthException catch (error) {
      print(error);
      print("Error");
      return error.message;
    } catch (e) {
      print(e);
    }
  }

//signin
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      return true;
    } on FirebaseAuthException catch (e) {
      print(e);

      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF('');
      await HelperFunction.saveUsernameSF('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
