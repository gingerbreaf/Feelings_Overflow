import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:status_alert/status_alert.dart';
import '../../../../design/follow_button.dart';

class OtherUserProfile extends StatefulWidget {
  /// UID of user to be displayed
  final String uid;

  const OtherUserProfile({required this.uid, Key? key}) : super(key: key);

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  bool outlineSelected = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Whether to show a loading icon
  bool isLoading = false;

  /// Contains information about the user
  var userData = {};
  int followers = 0;
  int following = 0;
  int postLength = 0;

  /// Whether to show follow button or unfollow button
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Gets relevant information about the user to be displayed from Firestore
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await _firestore.collection('users').doc(widget.uid).get();
      // Getting post length
      var postSnap = await _firestore
          .collection('users')
          .doc(widget.uid)
          .collection('personal_diaries')
          .get();
      postLength = postSnap.docs.length;

      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers'].contains(_auth.currentUser!.uid);
      setState(() {});
    } catch (e) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: 'Could not fetch information about user',
        subtitle: 'Try again later',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    }
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
            appBar: AppBar(),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                NetworkImage(userData['profilepic']),
                          )
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
                          child: Column(
                            children: <Widget>[
                              Text(
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
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? Container(
                                height: 0,
                              )
                            : isFollowing
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
                    height: 30.0,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 30,
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            // TODO: Change this to the diary Cards instead
                            return Container(
                              color: Colors.white,
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
