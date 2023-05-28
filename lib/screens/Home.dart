import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  static const id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Feelings Overflow',
          style: GoogleFonts.lato(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
