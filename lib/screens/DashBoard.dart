import 'package:feelings_overflow/screens/tabs/HomeTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tabs/MyDiariesTab.dart';
import 'tabs/HomeTab.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  static const id = 'dashboard_screen';

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  int _currentIndex = 0;

  final tabs = [
    HomeTab(),
    MyDiariesTab(),
    Center(
      child: Text(
        'Profile Page',
      ),
    ),
    //put profile page here
  ];

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.book,
            ),
            label: 'My Diaries',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.profile_circled,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
