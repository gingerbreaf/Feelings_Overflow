import 'package:feelings_overflow/screens/tabs/HomeTab/HomeTab.dart';
import 'package:feelings_overflow/screens/tabs/SearchTab/SearchTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tabs/MyDiariesTab/MyDiariesTab.dart';
import 'tabs/ProfileTab/ProfileTab.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  static const id = 'dashboard_screen';

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  /// The index for navigation bar
  int _currentIndex = 0;

  /// Array containing the tabs for navigation bar
  final tabs = [
    const HomeTab(),
    SearchTab(),
    const MyDiariesTab(),
    ProfileTab(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
              Icons.search,
            ),
            label: 'Search',
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
        unselectedItemColor: Colors.grey.shade700,
        enableFeedback: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
