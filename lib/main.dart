// main.dart file
import 'package:feelings_overflow/screens/tabs/ProfileTab/follower_screen.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/following_screen.dart';
import 'package:feelings_overflow/screens/tabs/HomeTab/new_post_screen.dart';
import 'package:feelings_overflow/screens/tabs/MyDiariesTab/MyDiariesTab.dart';
import 'package:feelings_overflow/screens/login_screen.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:feelings_overflow/screens/DashBoard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// initializing the firebase app
  await Firebase.initializeApp();

  await FirebaseApi().initNotifications();

// calling of runApp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const FeelingsOverflow());
  });
}

class FeelingsOverflow extends StatefulWidget {
  const FeelingsOverflow({super.key});

  @override
  State<FeelingsOverflow> createState() => _FeelingsOverflow();
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
        useMaterial3: true,
      ),
      // Initial start screen
      initialRoute: LoginScreen.id,
      routes: {
        'dashboard_screen': (context) => const DashBoard(),
        'login_screen': (context) => const LoginScreen(),
        'registration_screen': (context) => const RegistrationScreen(),
        'mydiaries_screen': (context) => const MyDiariesTab(),
        'following_screen': (context) => FollowingScreen(),
        'follower_screen': (context) => const FollowerScreen(),
        'new_post_screen': (context) => const NewPostScreen(),
      },
      // home property contain SignInScreen widget
    );
  }
}
