import 'package:bloc/bloc.dart';
import 'package:chat_app/firebase_section/auth_status_enum.dart';
import 'package:chat_app/firebase_section/autication.dart';
import 'package:chat_app/pages/chatScreen/screen/screen_chat.dart';
import 'package:chat_app/pages/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/shred_pref.dart';
import '../../chatScreen/screen/screen_detailed_chat.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.context) : super(SplashInitial()) {
    firebaseAuthServices.currentUser().then((userId) {
      authStatus =
          userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
    });
    splash();
    getStringSf();
  }
  BuildContext context;

// create instance of auth services
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  //intial status of splash.

  AuthStatus authStatus = AuthStatus.notSignedIn;

  String? email;
  getStringSf() async {
    SharedPreferences sh = await SharedPreferences.getInstance();

    email = sh.getString('email');
  
  }

  Future<void> splash() async {
    print('-----------------v2');
    Future.delayed(const Duration(seconds: 3), () {
      switch (authStatus) {
        case AuthStatus.notSignedIn:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
          break;
        case AuthStatus.signedIn:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenDetailedChat(emailId: email ?? '',)
          ));
          break;

        default:
      }
    });
  }
}
