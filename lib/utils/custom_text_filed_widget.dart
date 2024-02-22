import 'package:flutter/material.dart';

class CustomTextFiledWidget extends StatelessWidget {
  const CustomTextFiledWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator

  });
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller,
      validator: validator,
      decoration: InputDecoration(
      
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText),
    );
  }
}
