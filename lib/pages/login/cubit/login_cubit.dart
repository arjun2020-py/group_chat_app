import 'package:bloc/bloc.dart';
import 'package:chat_app/pages/chatScreen/screen/screen_detailed_chat.dart';
import 'package:chat_app/utils/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase_section/autication.dart';
import '../../chatScreen/screen/screen_chat.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.context) : super(LoginInitial()) {}
  BuildContext context;
  TextEditingController usernameController = TextEditingController(),
      passwrodController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user_chat_collection');

  usernameVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild username';
    }
  }

  passwrodVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild passwrod';
    }
  }

  siginUser() async {
    String email = usernameController.text;
    String password = passwrodController.text;

    User? user =
        await firebaseAuthServices.siginWithEmailAndPasswrod(email, password);

    if (user != null) {
      setStringSf(email);
      // chatTileClick(email);
      chatAppShowToast(message: 'User is succssfully sigign');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatScreen(email: email)));
    } else {
      chatAppShowToast(message: 'some error is occured');
    }
  }



  setStringSf(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('email', email);
    print('set email is ${sharedPreferences.setString('email', email)}');
  }
}
