import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:status_alert/status_alert.dart';


class DiaryPostingScreen extends StatefulWidget {
  DiaryPostingScreen(this.doc, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot doc;

  @override
  State<DiaryPostingScreen> createState() => _DiaryPostingScreenState();
}

class _DiaryPostingScreenState extends State<DiaryPostingScreen> {

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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.post_add),
        onPressed: () {
          FirebaseMethods.postDiary(widget.doc, FirebaseAuth.instance.currentUser!.uid);
          StatusAlert.show(
            context,
            duration: const Duration(seconds: 1),
            title: 'Diary posted',
            configuration:
            const IconConfiguration(icon: Icons.done),
            maxWidth: 260,
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }
      ),
    );
  }
}