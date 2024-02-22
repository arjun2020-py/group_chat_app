import 'package:bloc/bloc.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase_section/autication.dart';
import '../../login/login_screen.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.context) : super(RegisterInitial());
  BuildContext context;

  TextEditingController usernameController = TextEditingController(),
      nameController = TextEditingController(),
      mobileContoller = TextEditingController(),
      passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user_collection');

  usernameVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild username';
    }
  }

  nameVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild name';
    }
  }

  mobileVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild mobile no';
    }
  }

  passwrodVaildation(String value) {
    if (value.isEmpty) {
      return 'please enter vaild passwrod';
    }
  }

  registerMember() async {
    String email = usernameController.text;
    String name = nameController.text;
    String mobile = mobileContoller.text;
    String password = passwordController.text;

    //assgin text controller values to crrssopding collection keys

    Map<String, String> dataToSend = {
      "email": email,
      "name": name,
      "mobile": mobile,
      "password": password
    };

    //add the map  data to collection 'user_collection'
    collectionReference.add(dataToSend);

    User? user =
        await firebaseAuthServices.siginupWithEmailAndPasswrod(email, password);

    if (user != null) {
      setStringSF(nameController.text);
      chatAppShowToast(message: 'user siginup sucssfully');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(name: nameController.text),
      ));
    } else {
      chatAppShowToast(message: 'some error is occured');
    }
  }

  setStringSF(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name', name);
  }
}
