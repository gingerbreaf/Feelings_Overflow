import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_style.dart';
import 'rich_text_display.dart';
import 'package:feelings_overflow/functionality/JsonCoding.dart';

/// Cards to be used in homepage feed for previews of posts
class HomePageDiaryCard extends StatefulWidget {
  final Function()? onTap;

  /// Contains information about the diary/ post
  final QueryDocumentSnapshot doc;

  const HomePageDiaryCard({super.key, this.onTap, required this.doc});

  @override
  State<HomePageDiaryCard> createState() => _HomePageDiaryCardState();
}

class _HomePageDiaryCardState extends State<HomePageDiaryCard> {
  bool isLoading = false;
  String picUrl = 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
  String posterName = '';

  @override
  void initState() {
    getData();
    super.initState();
    print(picUrl);
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
    picUrl = await userData['profilepic'];
    posterName = userData['username'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.cardsColor[widget.doc['color_id']],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                              NetworkImage(picUrl),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          posterName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.doc["diary_title"],
                style: AppStyle.mainTitle,
              ),
              Text(
                widget.doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              RichTextDisplay(
                interactive: false,
                controller: JsonCoding.getQuillControllerviaJSON(
                    widget.doc["diary_content"]),
              ),
              // OLD TEXT DISPLAY
              // Text( widget.doc["diary_content"], style: AppStyle.dateTitle,)
            ],
          ),
        ),
      ),
    );
  }
}
