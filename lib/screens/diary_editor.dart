import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class DiaryEditorScreen extends StatefulWidget {
  const DiaryEditorScreen({Key? key}) : super(key: key);

  @override
  State<DiaryEditorScreen> createState() => _DiaryEditorScreenState();
}

class _DiaryEditorScreenState extends State<DiaryEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length); //choose random color
  String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.cardsColor[color_id],
        appBar: AppBar(
          backgroundColor: AppStyle.cardsColor[color_id],
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black,),
          title: const Text('Create a new Diary', style: TextStyle(
            color: Colors.black,
          )),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
            Text(date, style: AppStyle.dateTitle,),
            const SizedBox(
              height: 30,
            ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          FirebaseFirestore.instance.collection("Diaries").add({
            "diary_title": _titleController.text,
            "creation_date": date,
            "diary_content": _mainContentController.text,
            "color_id" : color_id,
          }).then((value) {
            print(value.id);
            Navigator.pop(context);
          }).catchError((error) => print("error"));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
