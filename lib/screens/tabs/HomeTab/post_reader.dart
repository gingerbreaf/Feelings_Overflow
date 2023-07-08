import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:intl/intl.dart';
import 'package:feelings_overflow/design/rich_text_display.dart';
import 'package:feelings_overflow/functionality/JsonCoding.dart';

class PostReaderScreen extends StatefulWidget {
  const PostReaderScreen(this.doc, {Key? key}) : super(key: key);

  /// Contains information about the user
  final QueryDocumentSnapshot doc;

  @override
  State<PostReaderScreen> createState() => _PostReaderScreenState();
}

class _PostReaderScreenState extends State<PostReaderScreen> {
  bool isLoading = false;

  String picUrl = '';
  String posterName = '';

  @override
  void initState() {
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doc['poster_uid'])
        .get();
    var userData = userSnap.data()!;
    picUrl = userData['profilepic'];
    posterName = userData['username'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int colorID = widget.doc['color_id'];
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
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(picUrl),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          posterName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.doc["diary_title"],
                style: AppStyle.mainTitle.copyWith(
                  fontSize: 28,
                ),
              ),
              Text(
                'Written on ' + widget.doc["creation_date"],
                style: AppStyle.dateTitle.copyWith(fontSize: 15),
              ),
              Text(
                'Posted on ' + DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.doc['post_date'])),
                style: AppStyle.dateTitle.copyWith(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              RichTextDisplay(
                controller: JsonCoding.getQuillControllerviaJSON(
                    widget.doc["diary_content"]),
              ),
              /* Old way of text display
              Text(
                widget.doc["diary_content"],
                style: AppStyle.mainContent,
              )
             */
            ],
          ),
        ),
      ),
    );
  }
}
