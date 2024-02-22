import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/custom_text_filed_widget.dart';
import '../../utils/custom_text_widget.dart';
import '../register/screen_register.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, this.name});

  String? name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          var cubit = context.read<LoginCubit>();
          return Scaffold(
              body: SafeArea(
            child: Form(
              key: cubit.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextWidget(
                      text: 'Login',
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFiledWidget(
                    controller: cubit.usernameController,
                    validator: (value) => cubit.usernameVaildation(value!),
                    hintText: 'username',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFiledWidget(
                    controller: cubit.passwrodController,
                    validator: (value) => cubit.passwrodVaildation(value!),
                    hintText: 'password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                     
                          cubit.siginUser();
                        }
                      },
                      child: Text('Login')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                          text: "Don't have an account",
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                          },
                          child: CustomTextWidget(
                              text: 'Register ?',
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
