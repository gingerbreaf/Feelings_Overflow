import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethods {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;


  static Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {

      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static void postDiary(QueryDocumentSnapshot diary, String uid) async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      var userData = userSnap.data()!;
      DocumentSnapshot snap = await _firestore.collection('users')
          .doc(uid)
          .get();
      List followers = (snap.data()! as dynamic)['followers'];
      print(followers.length);
      for (String follower in followers) {
        _firestore.collection("users")
            .doc(follower)
            .collection("homepage_feed").add({
          "poster_uid": uid,
          "poster_name": userData['username'],
          "diary_title": diary['diary_title'],
          "creation_date": diary['creation_date'],
          "diary_content": diary['diary_content'],
          "color_id" : diary['color_id'],
        }).then((value) {
          print(value.id);
        }).catchError((error) => print("error"));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}