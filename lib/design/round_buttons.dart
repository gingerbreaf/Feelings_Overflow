import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final void Function() onPress;
  final Color color;
  final String title;

  const RoundedButton({super.key, required this.color, required this.onPress, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            this.title,
          ),
        ),
      ),
    );
  }
}