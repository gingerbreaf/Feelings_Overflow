import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/screens/tabs/MyDiariesTab/diary_editor.dart';
import 'package:feelings_overflow/screens/tabs/MyDiariesTab/diary_creator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

/// This is the UI for My Diaries Tab which displays all the diaries you created.
class MyDiariesTab extends StatefulWidget {
  const MyDiariesTab({Key? key}) : super(key: key);

  @override
  State<MyDiariesTab> createState() => _MyDiariesTabState();
}

class _MyDiariesTabState extends State<MyDiariesTab> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Diaries',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("personal_diaries")
                        .orderBy('creation_timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> listOfDocs =
                            snapshot.data!.docs;

                        return listOfDocs.isEmpty
                            ? const Center(
                                child: Text(
                                    "You have no diaries. Create a new one!"))
                            : GridView(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                children: listOfDocs
                                    .map((diary) => DiaryCard(
                                          doc: diary,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DiaryEditorScreen(
                                                          diary), // Create new instance of DiaryReaderScreen with respective diary data
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const DiaryCreatorScreen(), // Create new instance of DiaryEditorScreen
                ));
          },
          label: const Text('New Diary'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
