import 'package:chat_app/pages/login/login_screen.dart';
import 'package:chat_app/utils/custom_toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> siginupWithEmailAndPasswrod(
      String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      //email is duplicate

      if (e.code == 'email-is-allready-in-use') {
        chatAppShowToast(message: 'email address is allready in use');
      } else {
        chatAppShowToast(message: 'an error is occured ${e.code}');
      }
    }
  }

  Future<User?> siginWithEmailAndPasswrod(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      //email is created or not
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        chatAppShowToast(message: 'invaild email id and passwrod');
      } else {
        chatAppShowToast(message: 'An error is occured ${e.code}');
      }
    }
  }

  Future<String> currentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future siginOut(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }
}
