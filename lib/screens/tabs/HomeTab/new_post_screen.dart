import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/screens/tabs/HomeTab/diary_posting_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class NewPostScreen extends StatefulWidget {
  static const String id = 'new_post_screen';
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select a diary to post',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("personal_diaries")
                        .orderBy("creation_timestamp", descending: true)
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
                                  crossAxisCount: 2),
                          children: snapshot.data!.docs
                              .map((diary) => DiaryCard(
                                    doc: diary,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DiaryPostingScreen(
                                                    diary), // Create new instance of DiaryPostingScreen with respective diary data
                                          ));
                                    },
                                  ))
                              .toList(),
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
      ),
    );
  }
}
