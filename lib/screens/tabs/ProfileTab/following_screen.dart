import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/other_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

class FollowingScreen extends StatefulWidget {
  static const String id = 'following_screen';
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  /// Whether to show results of the search for other users
  bool isShowUsers = false;

  /// List of strings of followings' UID
  List<String> followingUid = [];

  /// List of strings of followings' usernames
  List<String> followingName = [];

  /// List of strings of followings' profile picture URL
  List<String> followingPicUrl = [];

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

  /// Gets relevant information about the following
  void getFollowing() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      var userData = userSnap.data()!;
      followingUid =
          (userData['following'] as List).map((e) => e as String).toList();
      for (String uid in followingUid) {
        String name = await getUsername(uid);
        followingName.add(name);
        String picUrl = await getPicUrl(uid);
        followingPicUrl.add(picUrl);
      }
    } catch (e) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        subtitle: 'Could not get following, try again later',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for users to follow',
          ),
          onFieldSubmitted: (value) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isShowUsers
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isNotEqualTo: widget.currentUserUid,
                          isGreaterThanOrEqualTo: searchController.text)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          NetworkImage image = NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['profilepic']);
                          return ListTile(
                            leading: CircleAvatar(backgroundImage: image),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                            ),
                            onTap: () {
                              // Navigate to the profile page of the respective user
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtherUserProfile(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]['uid'])));
                              //FirebaseMethods.followUser(widget.uid, (snapshot.data! as dynamic).docs[index]['uid']);
                            },
                          );
                        });
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: followingUid.map((uid) {
                          String name =
                              followingName[followingUid.indexOf(uid)];
                          return ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(followingPicUrl[
                                      followingUid.indexOf(uid)])),
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
