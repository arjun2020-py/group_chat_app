import 'package:chat_app/utils/custom_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/splash_cubit.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});
   
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(context),
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          var cubit = context.read<SplashCubit>();
          return Scaffold(
            body: Center(
              child: CustomTextWidget(
                  text: 'Chat App',
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
