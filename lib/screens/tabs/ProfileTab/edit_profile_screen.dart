import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/login_register_text_fields.dart';
import 'package:status_alert/status_alert.dart';

/// This is the UI screen for editing a profile's detail
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  /// Information about the user
  var userData = {};

  /// The new username
  String username = '';

  /// The new bio
  String bio = '';

  /// Whether to show a loading icon
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginRegisterTextField(
                hintText: 'New Username',
                obscure: false,
                onChanged: (value) {
                  username = value;
                },
                email: false),
            LoginRegisterTextField(
                hintText: 'New Bio',
                obscure: false,
                onChanged: (value) {
                  bio = value;
                },
                email: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Change Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  // Check if either of the fields are filled
                  if (username == '' && bio == '') {
                    StatusAlert.show(
                      context,
                      duration: const Duration(seconds: 1),
                      title: 'Fields are empty, please fill in the details',
                      configuration: const IconConfiguration(icon: Icons.close),
                      maxWidth: 260,
                    );
                  } else {
                    setState(() {
                      showSpinner = true;
                    });
                    var userSnap = await _firestore
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .get();
                    userData = userSnap.data()!;
                    final String existingUsername = userData['username'];
                    final String existingBio = userData['bio'];
                    // If username is unfilled, or it is already existing
                    if (existingUsername == username || username == '') {
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({
                        'bio': bio,
                      });
                    } else if (existingBio == bio || bio == '') {
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({
                        'username': username,
                      });
                    } else {
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({
                        'bio': bio,
                        'username': username,
                      });
                    }
                    StatusAlert.show(
                      context,
                      duration: const Duration(seconds: 1),
                      title: 'Update successful',
                      configuration: const IconConfiguration(icon: Icons.done),
                      maxWidth: 260,
                    );
                    Navigator.pop(context);
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
