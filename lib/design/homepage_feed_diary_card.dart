import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_style.dart';

class HomePageDiaryCard extends StatelessWidget {
  final Function()? onTap;
  final QueryDocumentSnapshot doc;

  const HomePageDiaryCard({super.key, this.onTap, required this.doc});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
                  const CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        AssetImage('assets/images/defaultprofile.jpg'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    doc['poster_name'],
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
