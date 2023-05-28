import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationBarButton extends StatelessWidget {
  final String txt;
  final void Function()? onPress;

  NavigationBarButton({
    required this.txt,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Icon(FontAwesomeIcons.home),
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
