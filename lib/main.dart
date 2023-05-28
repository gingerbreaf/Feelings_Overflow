// main.dart file
import 'package:feelings_overflow/screens/login_screen.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:feelings_overflow/screens/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// initializing the firebase app
  await Firebase.initializeApp();

// calling of runApp
  runApp(FeelingsOverflow());
}

class FeelingsOverflow extends StatefulWidget {
  @override
  _FeelingsOverflow createState() => _FeelingsOverflow();
}

class _FeelingsOverflow extends State<FeelingsOverflow> {
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
      // Initial start screen
      initialRoute: WelcomeScreen.id,
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'home_screen': (context) => Home(),
        'login_screen' : (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),

      },
      // home property contain SignInScreen widget
      home: LoginScreen(),
    );
  }
}
