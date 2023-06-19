import 'package:feelings_overflow/screens/new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feelings_overflow/design/homepage_feed_diary_card.dart';
import 'package:feelings_overflow/screens/post_reader.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String username = '';

  Future<String> getUsername() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    var userData = userSnap.data()!;
    return userData['username'];
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NewPostScreen.id);
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 30,
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("homepage_feed")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                        children: snapshot.data!.docs
                            .map((diary) => HomePageDiaryCard(
                          doc: diary,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostReaderScreen(
                                      diary), // Create new instance of DiaryReaderScreen with respective diary data
                                ));
                          },
                        )).toList(),
                      );
                    }
                    return const Text(
                        "You have no diaries. Create a new one!");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
