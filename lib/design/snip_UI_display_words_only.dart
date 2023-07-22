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
      child: InkWell(
        onTap: widget.onTap,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'assets/images/${widget.doc["card_background"]}.jpg'),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 4,
                                right: MediaQuery.of(context).size.width / 4,
                              ),
                              child: RichTextDisplayPost(
                                controller:
                                    JsonCoding.getQuillControllerviaJSON(
                                        widget.doc["diary_content"]),
                                interactive: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Created on ${DateFormat('d MMMM y HH:mm').format(widget.doc['creation_timestamp'].toDate())}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

/*


 */
