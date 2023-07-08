import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/functionality/JsonCoding.dart';
import 'package:flutter/material.dart';
import 'app_style.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'rich_text_display.dart';

/// Cards to be used in MyDiariesTab page for showing previews of personal diaries
class DiaryCard extends StatelessWidget {
  final Function()? onTap;

  /// Contains relevant information about the diary
  final QueryDocumentSnapshot doc;

  const DiaryCard({super.key, this.onTap, required this.doc});

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
              Text(
                doc["diary_title"],
                style: AppStyle.mainTitle,
              ),
              Text(
                doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              RichTextDisplay(
                controller: JsonCoding.getQuillControllerviaJSON(
                    doc["diary_content"]
                ),
              ),
              /* Old Text Representation
              Text(
                doc["diary_content"],
                style: AppStyle.mainContent,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )
              */
            ],
          ),
        ),
      ),
    );
  }
}
