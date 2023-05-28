import 'package:flutter/material.dart';

class WelcomeScnButton extends StatelessWidget {
  final String txt;
  final void Function()? onPress;

  WelcomeScnButton({
    required this.txt,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            txt,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      // by onpressed we call the function signup function
      onPressed: this.onPress,
    );
  }
}
