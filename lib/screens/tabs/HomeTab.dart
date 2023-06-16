import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String username = '';

  String getUsername() {
    String user = '';
    _firestore.collection("users")
        .doc(_auth.currentUser!.uid).get().then((value) {
          user = value.data()?["username"];
    });
    return user;
  }

  @override
  void initState() {
    super.initState();
    username = getUsername();
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posts',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
