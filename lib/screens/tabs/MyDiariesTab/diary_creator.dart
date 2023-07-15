import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/follow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:feelings_overflow/design/rich_text_toolbar.dart';

class DiaryCreatorScreen extends StatefulWidget {
  const DiaryCreatorScreen({Key? key}) : super(key: key);

  @override
  State<DiaryCreatorScreen> createState() => _DiaryCreatorScreenState();
}

class _DiaryCreatorScreenState extends State<DiaryCreatorScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// The background color of the diary which is randomly generated
  int colorID = Random().nextInt(AppStyle.cardsColor.length);

  /// Current data and time which will be part of the diary's information
  String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());


  final TextEditingController _titleController = TextEditingController();

  // Old Diary editing of content
  //final TextEditingController _mainContentController = TextEditingController();

  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorID],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[colorID],
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text('Create a new Diary',
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RichTextToolbar(controller: _controller),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: AppStyle.mainTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                date,
                style: AppStyle.dateTitle,
              ),
              const SizedBox(
                height: 30,
              ),
              QuillEditor.basic(controller: _controller, readOnly: false,
              ),
              /* Old Text Editor for Body
              TextField(
                controller: _mainContentController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Your Diary here',
                ),
                style: AppStyle.mainContent,
                maxLines: null,
              ),
              */
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          var json = jsonEncode(_controller.document.toDelta().toJson());
          _firestore
              .collection("users")
              .doc(_auth.currentUser!.uid)
              .collection("personal_diaries")
              .add({
            "diary_title": _titleController.text,
            "creation_date": date,
            //"diary_content": _controller.document.toPlainText(),
            "diary_content": json,
            // Previous approach for TextEditingController
            //"diary_content": _mainContentController.text,
            "color_id": colorID,
          }).then((value) {
            Navigator.pop(context);
          }).catchError((error) => print("error"));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
