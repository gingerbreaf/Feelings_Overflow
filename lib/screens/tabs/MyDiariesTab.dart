import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/screens/diary_reader.dart';
import 'package:feelings_overflow/screens/diary_editor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyDiariesTab extends StatefulWidget {
  const MyDiariesTab({Key? key}) : super(key: key);

  @override
  State<MyDiariesTab> createState() => _MyDiariesTabState();
}

class _MyDiariesTabState extends State<MyDiariesTab> {
  final _firestore = FirebaseFirestore.instance;

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
              const Text(
                'My Diaries',
                style: TextStyle(
                  fontSize:35,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('Diaries').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((diary) => DiaryCard(doc: diary, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiaryReaderScreen(diary), // Create new instance of DiaryReaderScreen with respective diary data
                          ));
                      },)).toList(),
                      );
                    }
                    return const Text("You have no diaries. Create a new one!");
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
                    const DiaryEditorScreen(), // Create new instance of DiaryReaderScreen with respective diary data
              ));
        },
        label: const Text('New Diary'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
