import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/design/snip_UI_display_words_only.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:feelings_overflow/design/profile_display_card.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/edit_profile_screen.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/following_screen.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/follower_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:feelings_overflow/functionality/image_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_alert/status_alert.dart';

import '../../../design/follow_button.dart';
import 'package:feelings_overflow/screens/login_screen.dart';

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

  /// Whether to show a loading icon
  bool isLoading = false;

  /// The URL of the profile picture to be displayed
  String imageURL = '';

  /// Contains information of the user
  var userData = {};
  int followers = 0;
  int following = 0;
  int postLength = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Retrieves all relevant data about the current user
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
          .collection('personal_diaries')
          .get();
      postLength = postSnap.docs.length;

      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      imageURL = userData['profilepic'];
      setState(() {});
    } catch (e) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: 'Unable to fetch details',
        subtitle: 'Try again later',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Lets the user select an image for profile picture
  void selectImage() async {
    Uint8List im = await ImageFunction.pickImage(ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    ImageFunction.uploadFile(im, widget.uid);
    String profilePicURL = await ImageFunction.getDownloadURL(widget.uid);
    FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
      'profilepic': profilePicURL,
    });
    setState(() {
      imageURL = profilePicURL;
    });
    print(profilePicURL);
    setState(() {
      isLoading = false;
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(imageURL),
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
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, FollowerScreen.id);
                          },
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("users").doc(widget.uid).snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data!.data();
                                      followers = data!['followers'].length;
                                      return Text(
                                        followers.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        followers.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  }
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
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("users").doc(widget.uid).snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data!.data();
                                      following = data!['following'].length;
                                      return Text(
                                        following.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        following.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  }
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
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("users").doc(widget.uid).collection('posts').snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data!.docs;
                                      postLength = data.length;
                                      return Text(
                                        postLength.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        postLength.toString(),
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  }
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
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: FollowButton(
                              text: 'Edit Profile',
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              borderColor: Colors.grey,
                              function: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfile()))
                                    .then((value) => setState(() {
                                          getData();
                                        }));
                              }),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      child: const Text('Sign Out'),
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
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Post History',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .collection('posts')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return (snapshot.data! as dynamic).docs.length == 0
                          ? const Padding(
                              padding: EdgeInsets.all(80.0),
                              child: Center(
                                child: Text(
                                  'No Posts to Show',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                // TODO: Change this to the diary Cards instead
                                return snap['display_type'] == 'WORDONLYDISPLAY'
                                    ? WordOnlyDisplayProfile(doc: snap)
                                    : DiaryCard(doc: snap);
                                //return DiaryCard(doc: snap);
                              });
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
