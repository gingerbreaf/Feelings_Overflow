import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../functionality/JsonCoding.dart';
import 'rich_text_for_posting.dart';

class WordOnlyDisplayProfile extends StatefulWidget {
  final Function()? onTap;

  final QueryDocumentSnapshot doc;
  const WordOnlyDisplayProfile({super.key, required this.doc, this.onTap});

  @override
  State<WordOnlyDisplayProfile> createState() => _WordOnlyDisplayProfileState();
}

class _WordOnlyDisplayProfileState extends State<WordOnlyDisplayProfile> {
  bool isLoading = false;


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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: widget.onTap,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/${widget.doc["card_background"]}.jpg'),
                  ),
                ),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: RichTextDisplayPost(controller: JsonCoding.getQuillControllerviaJSON(
                          widget.doc["diary_content"]), interactive: false,),
                    ),
                  ],
                ),
              ),
              Text(
                'Created on ${DateFormat('d MMMM y HH:mm').format(widget.doc['creation_timestamp'].toDate())}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
      ],
      ),
        )
      )
    );
  }
}

/*


 */