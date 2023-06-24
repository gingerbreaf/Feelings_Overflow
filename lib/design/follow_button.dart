import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowButton extends StatelessWidget {
  /// Function to be called when button is pressed
  final Function()? function;

  /// Background color of the button
  final Color backgroundColor;

  /// Border color of the button
  final Color borderColor;

  /// Text to be displayed on the button
  final String text;

  /// Color of the text to be displayed on the button
  final Color textColor;

  const FollowButton(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 250,
          height: 27,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
