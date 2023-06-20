import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/screens/tabs/ProfileTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';

class FollowingScreen extends StatefulWidget {
  static const String id = 'following_screen';
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text
        ).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/defaultprofile.jpg')
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username'],),
                  onTap: () {
                    // Navigate to the profile page of the respective user
                    Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ProfileTab(
                              uid: (snapshot.data! as dynamic).docs[index]['uid']
                          )));
                    //FirebaseMethods.followUser(widget.uid, (snapshot.data! as dynamic).docs[index]['uid']);
                  },
                );
          });
        },
      ) : const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Following',
              style: TextStyle(
                fontSize: 25,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
