import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/edit_profile_screen.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/following_screen.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab/follower_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:feelings_overflow/functionality/image_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_alert/status_alert.dart';

import '../ProfileTab/other_user_profile.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key? key}) : super(key: key);

  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  /// Whether to show results of the search for other users
  bool isShowUsers = false;

  /// List of strings of followings' UID
  List<String> requestsUid = [];

  /// List of strings of followings' usernames
  List<String> requestsName = [];

  /// List of strings of followings' profile picture URL
  List<String> requestsPicUrl = [];

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
  void getRequests() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      var userData = userSnap.data()!;
      requestsUid =
          (userData['requests'] as List).map((e) => e as String).toList();
      for (String uid in requestsUid) {
        String name = await getUsername(uid);
        requestsName.add(name);
        String picUrl = await getPicUrl(uid);
        requestsPicUrl.add(picUrl);
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
    getRequests();
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
      body: isShowUsers
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
                          (snapshot.data! as dynamic).docs[index]['username'],
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
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Follow Requests',
                    style: TextStyle(fontSize: 20),
                  ),
                  requestsUid.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Center(
                              child: Text(
                            'Follow requests will appear here',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          )))
                      : ListView(
                          shrinkWrap: true,
                          children: requestsUid.map((uid) {
                            String name =
                                requestsName[requestsUid.indexOf(uid)];
                            return ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(requestsPicUrl[
                                      requestsUid.indexOf(uid)])),
                              title: Text(name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: IconButton(
                                      onPressed: () {
                                        FirebaseMethods.followUser(
                                            uid, widget.currentUserUid);
                                        FirebaseMethods.requestFollow(
                                            uid, widget.currentUserUid);
                                        setState(() {
                                          requestsUid.remove(uid);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: IconButton(
                                      onPressed: () {
                                        FirebaseMethods.requestFollow(
                                            uid, widget.currentUserUid);
                                        setState(() {
                                          requestsUid.remove(uid);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}
