import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/screens/following_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:feelings_overflow/functionality/image_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_alert/status_alert.dart';

class ProfileTab extends StatefulWidget {
  final String uid;
  const ProfileTab({required this.uid, Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  //TODO: setuseMaterial in our main dart, Theme, this is for button toggle
  bool outlineSelected = false;
  //TODO: Add a function that determines the index and deselect all other buttons

  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  Uint8List? _image;
  var userData = {};
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      setState(() {});
    } catch (e) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: e.toString(),
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectImage() async {
    Uint8List im = await ImageFunction.pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: SizedBox(
                            height: 30.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                          color: Colors.grey.shade500,
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  //Insert default network image for profile
                                  backgroundImage:
                                      AssetImage('assets/images/download.jpg'),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 90,
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          userData['username'],
                          style: GoogleFonts.montserrat(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['bio'],
                          style: GoogleFonts.montserrat(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Text(
                                // TODO: Insert follower count based on actual count
                                followers.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, FollowingScreen.id);
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                // TODO: Insert following count based on actual
                                following.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Following',
                                style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 8,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Text(
                                // TODO: Insert follower count based on actual count
                                '5',
                                style: GoogleFonts.openSans(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Posts',
                                style: GoogleFonts.openSans(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        IconButton.filled(
                          onPressed: () {
                            setState(() {
                              outlineSelected = !outlineSelected;
                              print(outlineSelected);
                            });
                          },
                          isSelected: outlineSelected,
                          icon: const Icon(Icons.library_books_outlined),
                          selectedIcon: const Icon(Icons.library_books),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 2.0,
                    color: Colors.black,
                  ),
                  Center(
                    child: TextButton(
                      child: Text(
                        'Sign Out'
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                        StatusAlert.show(
                          context,
                          duration: const Duration(milliseconds: 500),
                          title: 'You are signed out',
                          configuration:
                          const IconConfiguration(icon: Icons.done),
                          maxWidth: 260,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
