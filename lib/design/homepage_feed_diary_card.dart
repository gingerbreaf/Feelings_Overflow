import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_style.dart';

/// Cards to be used in homepage feed for previews of posts
class HomePageDiaryCard extends StatelessWidget {
  final Function()? onTap;

  /// Contains information about the diary/ post
  final QueryDocumentSnapshot doc;

  const HomePageDiaryCard({super.key, this.onTap, required this.doc});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.cardsColor[doc['color_id']],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(doc['poster_profile_pic']),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    doc['poster_name'],
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
                doc["diary_title"],
                style: AppStyle.mainTitle,
              ),
              Text(
                doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              Text(
                doc["diary_content"],
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
