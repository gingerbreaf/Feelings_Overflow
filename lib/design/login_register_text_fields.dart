import 'package:flutter/material.dart';

class LoginRegisterTextField extends StatelessWidget {
  const LoginRegisterTextField(
      {required this.hintText,
      required this.obscure,
      required this.onChanged,
      required this.email,
      Key? key})
      : super(key: key);
  final String? hintText;
  final bool obscure;
  final Function(String)? onChanged;
  final bool email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            keyboardType:
                email ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            onChanged: onChanged,
            textInputAction: TextInputAction.next,
            obscureText: obscure,
          ),
        ),
      ),
    );
  }
}
