import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DiaryReaderScreen extends StatefulWidget {
  const DiaryReaderScreen(this.doc, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot doc;

  @override
  State<DiaryReaderScreen> createState() => _DiaryReaderScreenState();
}

class _DiaryReaderScreenState extends State<DiaryReaderScreen> {

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["diary_title"],
              style: AppStyle.mainTitle.copyWith(
                fontSize: 28,
              ),
            ),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle.copyWith(
                fontSize: 15
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.doc["diary_content"],
              style: AppStyle.mainContent,
            )
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue,
      child: const Icon(Icons.delete),
      onPressed: () async {

        },
    ),
    );
  }

  Future deleteData(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("collection_name")
          .doc(id)
          .delete();
    } catch (e) {
      return false;
    }
  }
}
