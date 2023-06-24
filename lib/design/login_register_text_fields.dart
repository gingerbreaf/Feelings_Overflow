import 'package:flutter/material.dart';

class LoginRegisterTextField extends StatelessWidget {
  const LoginRegisterTextField(
      {required this.hintText,
      required this.obscure,
      required this.onChanged,
      required this.email,
      Key? key})
      : super(key: key);

  /// Hint text to be displayed when text field is empty
  final String? hintText;

  /// Whether to obscure the user input
  final bool obscure;

  /// Function to be called when text field content changes
  final Function(String)? onChanged;

  /// Whether to request from the OS for a keyboard suitable for typing emails
  final bool email;

  // TODO: Add a field onceCompleted that is a function that does the action once
  // TODO: Box is filled, Add it in the constructor, should not be required

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
            // TODO: In order to make enter move to the relevant buttons
            // TODO: Need to fill up onEditingComplete, call a void function
            //onEditingComplete: onceCompleted,
          ),
        ),
      ),
    );
  }
}
