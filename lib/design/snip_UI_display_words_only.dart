import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String picUrl = '';
  String posterName = '';

  @override
  void initState() {
    getData();
    super.initState();
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
                'assets/images/${widget.doc["card_background"]}.jpg'),
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ),
                SizedBox(
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
                        child: RichTextDisplayPost(
                          controller: JsonCoding.getQuillControllerviaJSON(
                              widget.doc["diary_content"]),
                          interactive: false,
                        ),
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
