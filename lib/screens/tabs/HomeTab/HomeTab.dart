import 'package:feelings_overflow/design/snip_UI_display_words_only.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:feelings_overflow/screens/tabs/HomeTab/new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feelings_overflow/design/homepage_feed_diary_card.dart';
import 'package:feelings_overflow/screens/tabs/HomeTab/post_reader.dart';
import 'package:rxdart/rxdart.dart';

/// This is the UI display for the Home Tab / Home page
class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _auth = FirebaseAuth.instance;

  /// Whether to show a loading icon
  bool isLoading = false;

  late CombineLatestStream<QuerySnapshot<Map<String, dynamic>>,
      List<QuerySnapshot<Map<String, dynamic>>>> stream;

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Fetches relevant data for the screen
  getData() async {
    setState(() {
      isLoading = true;
    });
    stream = await FirebaseMethods.getPosts(_auth.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
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
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: StreamBuilder<List<QuerySnapshot>>(
                        stream: stream,
                        builder: (context,
                            AsyncSnapshot<List<QuerySnapshot>> snapshotList) {
                          if (snapshotList.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshotList.hasData) {
                            List<QuerySnapshot<Object?>>? querySnapshot =
                                snapshotList.data;

                            List<QueryDocumentSnapshot> listOfDocumentSnapshot =
                                [];

                            querySnapshot?.forEach((query) {
                              listOfDocumentSnapshot.addAll(query.docs);
                            });

                            Iterable<QueryDocumentSnapshot> filteredList =
                                listOfDocumentSnapshot.where((docs) =>
                                    DateTime.parse(docs['post_date'])
                                        .difference(DateTime.now())
                                        .inMinutes
                                        .abs() <
                                    60 * 24);

                            return filteredList.isEmpty
                                ? const Center(
                                    child: Text('No Posts to show'),
                                  )
                                : GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    children: filteredList
                                        .map((diary) =>
                                       diary['display_type'] == 'WORDONLYDISPLAY'
                                        ? WordOnlyDisplay(doc: diary)
                                        : HomePageDiaryCard(
                                              doc: diary,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostReaderScreen(
                                                              diary), // Create new instance of PostReaderScreen with respective diary data
                                                    ));
                                              },
                                            ))
                                        .toList(),
                                  );
                          }
                          return const Center(child: Text("No Posts to show"));
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
