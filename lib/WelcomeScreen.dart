//SignInScreen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';
import 'package:feelings_overflow/design/WelcomeScnButton.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'Home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('assets/images/AppIcon.png'),
                height: 200.0,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Create an account and start jotting it down',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            WelcomeScnButton(
              txt: 'Log In',
              onPress: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Home();
                    },
                  ),
                ),
              },
            ),
            SizedBox(
              height: 15,
            ),
            WelcomeScnButton(
              txt: 'Sign Up',
              onPress: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
