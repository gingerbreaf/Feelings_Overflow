// main.dart file
import 'package:feelings_overflow/screens/tabs/MyDiariesTab.dart';
import 'package:feelings_overflow/screens/login_screen.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:feelings_overflow/screens/DashBoard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      // Initial start screen
      initialRoute: LoginScreen.id,
      routes: {
        'dashboard_screen': (context) => DashBoard(),
        'login_screen' : (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'mydiaries_screen': (context) => MyDiariesTab(),
      },
      // home property contain SignInScreen widget

    );
  }
}
