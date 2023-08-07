import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/other_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

/// This is the UI for viewing your followers
class FollowerScreen extends StatefulWidget {
  static const String id = 'follower_screen';
  const FollowerScreen({Key? key}) : super(key: key);

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// List of strings of followers' UID
  List<String> followerUid = [];

  /// List of strings of followers' usernames
  List<String> followerName = [];

  /// List of strings of followers' profile picture URL
  List<String> followerPicUrl = [];

  /// Whether to show a loading icon
  bool isLoading = false;

  /// Given a UID, gets the username from Firestore
  Future<String> getUsername(String uid) async {
    var userSnap = await _firestore.collection('users').doc(uid).get();
    var userData = userSnap.data()!;
    return userData['username'];
  }

  /// Given a UID, gets the profile picture URL from Firestore
  Future<String> getPicUrl(String uid) async {
    var userSnap = await _firestore.collection('users').doc(uid).get();
    var userData = userSnap.data()!;
    return userData['profilepic'];
  }

  /// Gets relevant information about the followers
  void getFollowers() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      var userData = userSnap.data()!;

      followerUid =
          (userData['followers'] as List).map((e) => e as String).toList();
      for (String uid in followerUid) {
        String name = await getUsername(uid);
        followerName.add(name);
        String picUrl = await getPicUrl(uid);
        followerPicUrl.add(picUrl);
      }
    } catch (e) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        subtitle: 'Could not get followers, try again later',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Followers',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: followerUid.map((uid) {
                      String name = followerName[followerUid.indexOf(uid)];
                      return ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  followerPicUrl[followerUid.indexOf(uid)])),
                          title: Text(name),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OtherUserProfile(uid: uid)));
                          });
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
