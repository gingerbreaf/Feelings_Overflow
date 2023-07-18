import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';

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
    super.initState();
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
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/backgroundPastel.jpg'),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'with or without me',
                      style: GoogleFonts.rochester(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*


 */