import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_style.dart';

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
              Text(
                widget.doc["diary_content"],
                style: AppStyle.mainContent,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
