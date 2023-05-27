// main.dart file
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'SignInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// initializing the firebase app
  await Firebase.initializeApp();

// calling of runApp
  runApp(GoogleSignIn());
}

class GoogleSignIn extends StatefulWidget {
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    // we return the MaterialApp here ,
    // MaterialApp contain some basic ui for android ,
    return MaterialApp(
      //materialApp title
      title: 'Feelings Overflow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      // home property contain SignInScreen widget
      home: SignInScreen(),
    );
  }
}
