import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/rich_text_display.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:feelings_overflow/functionality/JsonCoding.dart';

class DiaryEditorScreen extends StatefulWidget {
  const DiaryEditorScreen(this.doc, {Key? key}) : super(key: key);

  /// Carries information about the diary
  final QueryDocumentSnapshot doc;

  @override
  State<DiaryEditorScreen> createState() => _DiaryEditorScreenState();
}

class _DiaryEditorScreenState extends State<DiaryEditorScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final QuillController controller =
        JsonCoding.getQuillControllerviaJSON(widget.doc["diary_content"]);
    int colorID = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorID],
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              var json = jsonEncode(controller.document.toDelta().toJson());
              _firestore
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .collection("personal_diaries")
                  .doc(widget.doc.id)
                  .update({
                "diary_content": json,
                "last_updated_timestamp": Timestamp.now(),
              });
              Navigator.pop(context);
            }),
        backgroundColor: AppStyle.cardsColor[colorID],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                style: AppStyle.dateTitle.copyWith(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              QuillEditor.basic(
                controller: controller,
                readOnly: false,
                key1: const Key('Quill_Editor2'),
              ),

              // OLD WAY of displaying text
              /*
              Text(
                widget.doc["diary_content"],
                style: AppStyle.mainContent,
              )
              */
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.delete),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure you want to delete this diary?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No!! Please Don\'t'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  Navigator.pop(context);
                  deleteData(widget.doc.id);
                },
                child: const Text('Yes Please'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Deletes a document of ID id in personal_diaries collection on Firestore
  Future deleteData(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("personal_diaries")
          .doc(id)
          .delete();
    } catch (e) {
      return false;
    }
  }
}
