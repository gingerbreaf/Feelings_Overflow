import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../functionality/JsonCoding.dart';
import 'rich_text_for_posting.dart';

class WordOnlyDisplay extends StatefulWidget {
  final Function()? onTap;

  final QueryDocumentSnapshot doc;
  const WordOnlyDisplay({super.key, required this.doc, this.onTap});

  @override
  State<WordOnlyDisplay> createState() => _WordOnlyDisplayState();
}

class _WordOnlyDisplayState extends State<WordOnlyDisplay> {
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
    print(picUrl);
    posterName = userData['username'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/${widget.doc["card_background"]}.jpg'),
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch
              ,
              children: [
                Row(
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
                  height: 10.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 8,
                          right: MediaQuery.of(context).size.width / 8,
                        ),
                        child: RichTextDisplayPost(controller: JsonCoding.getQuillControllerviaJSON(
                            widget.doc["diary_content"]), interactive: false,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      'Created on ${DateFormat('d MMMM y HH:mm').format(widget.doc['creation_timestamp'].toDate())}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}