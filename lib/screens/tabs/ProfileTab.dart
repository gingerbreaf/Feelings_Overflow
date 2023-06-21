
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:feelings_overflow/screens/edit_profile_screen.dart';
import 'package:feelings_overflow/screens/following_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:feelings_overflow/functionality/image_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_alert/status_alert.dart';

import '../../design/follow_button.dart';

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
  int postLength = 0;
  bool isFollowing = false;

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
      // Getting post length
      var postSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('personal_diaries').get();
      postLength = postSnap.docs.length;

      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
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
                  // TODO: Remove if unnecessary
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
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Text(
                                followers.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 20.0,
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
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, FollowingScreen.id);
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                following.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 20.0,
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
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Text(
                                // TODO: Insert follower count based on actual count
                                postLength.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 20.0,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? Flexible(
                          child: FollowButton(
                            text: 'Edit Profile',
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            borderColor: Colors.grey,
                            function: (){
                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => EditProfile()))
                              .then((value) => setState((){
                                getData();
                              }));
                            }
                          ),
                        ) : isFollowing
                            ? FollowButton(
                              text: 'Unfollow',
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              borderColor: Colors.red,
                              function: () async {
                                await FirebaseMethods.followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uid'],
                                );
                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            )
                            : FollowButton(
                              text: 'Follow',
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white,
                              borderColor: Colors.green,
                              function: () async {
                                await FirebaseMethods.followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userData['uid'],
                                );
                                setState(() {
                                  isFollowing = true;
                                  followers++;
                                });
                              },
                            )
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
                  const Divider(
                    color: Colors.black,
                  ),

                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .collection('personal_diaries')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                            // TODO: Change this to the diary Cards instead
                            return Container(
                              child: Image(
                                image:  AssetImage('assets/images/download.jpg'),
                              ),
                            );

                          }
                      );
                    },

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
