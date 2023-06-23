import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethods {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;



  static Future<void> followUser(String uid, String followId) async {
    // This is not a streambuilder which is always listening for changes
    // This is a Future
    // Therefore IT IS IMPORTANT to setState in order to update values
    // upon using the function
    try {

      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        // Unfollowing a user, thus removing it from their page
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        // Unfollowing a user, thus updating the current user page
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });

      } else {
        // Following a user
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
      List followers = (userData as dynamic)['followers'];
      for (String follower in followers) {
        _firestore.collection("users")
            .doc(follower)
            .collection("homepage_feed").add({
          "poster_profile_pic": userData['profilepic'],
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