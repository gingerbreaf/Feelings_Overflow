import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feelings_overflow/design/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PostReaderScreen extends StatefulWidget {
  PostReaderScreen(this.doc, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot doc;

  @override
  State<PostReaderScreen> createState() => _PostReaderScreenState();
}

class _PostReaderScreenState extends State<PostReaderScreen> {

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                    NetworkImage(widget.doc['poster_profile_pic']),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.doc['poster_name'],
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
    );
  }
}