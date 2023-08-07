import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/screens/tabs/HomeTab/snip_screen.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:status_alert/status_alert.dart';
import 'package:feelings_overflow/design/rich_text_display.dart';
import 'package:feelings_overflow/functionality/JsonCoding.dart';


/// This is the UI after choosing a diary
/// Contains both the post and snippet function
class DiaryPostingScreen extends StatefulWidget {
  const DiaryPostingScreen(this.doc, {Key? key}) : super(key: key);

  /// Carries information about the diary
  final QueryDocumentSnapshot doc;

  @override
  State<DiaryPostingScreen> createState() => _DiaryPostingScreenState();
}

class _DiaryPostingScreenState extends State<DiaryPostingScreen> {

  @override
  Widget build(BuildContext context) {

    int colorID = widget.doc['color_id'];
    final QuillController quillController = JsonCoding.getQuillControllerviaJSON(
        widget.doc["diary_content"]);

    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorID],
      appBar: AppBar(
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
              RichTextDisplay(
                interactive: true,
                controller: quillController
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              // Need to add heroTag for multiple Floating Action Button
              heroTag: null,
              backgroundColor: Colors.white,
              child: const Icon(Icons.cut),
              onPressed: (){
                if (quillController.selection.isCollapsed) {
                  StatusAlert.show(
                    context,
                    duration: const Duration(seconds: 1),
                    title: 'Please Highlight A Valid Text',
                    configuration: const IconConfiguration(icon: Icons.error),
                    maxWidth: 260,
                  );
                } else if (quillController.selection.end - quillController.selection.start > 100) {
                  StatusAlert.show(
                    context,
                    duration: const Duration(seconds: 1),
                    title: 'Select shorter lengths',
                    configuration: const IconConfiguration(icon: Icons.error),
                    maxWidth: 260,
                  );
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      SnipScreen(quillController: quillController,)));
                }
              }),
          const SizedBox(width: 20.0,),
          FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.post_add),
              onPressed: () {
                FirebaseMethods.postDiary(
                    widget.doc, FirebaseAuth.instance.currentUser!.uid,);
                StatusAlert.show(
                  context,
                  duration: const Duration(seconds: 2),
                  title: 'Diary posted',
                  subtitle: 'Viewable for 24 hours',
                  configuration: const IconConfiguration(icon: Icons.done),
                  maxWidth: 260,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
