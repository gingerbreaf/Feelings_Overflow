import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:rxdart/rxdart.dart';


class FirebaseMethods {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Creates a default new profile for user registering
  ///
  /// Adds the data for the new user to the firebase backend
  static void settingNewProfile(String userUID, String username, String email) {
    FirebaseFirestore.instance.collection("users").doc(userUID).set({
      'username': username,
      'uid': userUID,
      'email': email,
      'bio': '',
      'followers': [],
      'following': [userUID],
      'requests': [],
      'profilepic':
          'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'
    });
  }

  /// Deals with the error code generated from registering using firebase
  ///
  /// Generates a response in accordance to the different auth exception code
  static void errorHandlingRegister(e, context) {
    print(e);
    if (e.code == 'network-request-failed') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'No Internet Connection',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    } else if (e.code == 'email-already-in-use') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Email already in use',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 260,
      );
    } else if (e.code == 'invalid-email') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Invalid email',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 260,
      );
    } else if (e.code == 'weak-password') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 3),
        title: 'Weak Password',
        subtitle: 'Needs at least 6 characters',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 500,
        dismissOnBackgroundTap: true,
      );
    } else {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Unknown Error',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 300,
      );
    }
  }

  /// Deals with the error code generated from Logging in using firebase
  ///
  /// Generates a response in accordance to the different auth exception code
  static void errorHandlingLogin(e, context) {
    if (e.code == 'network-request-failed') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'No Internet Connection',
        configuration: const IconConfiguration(icon: Icons.warning),
        maxWidth: 260,
      );
    } else if (e.code == 'invalid-email') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Invalid email',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 260,
      );
    } else if (e.code == 'wrong-password') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Password Incorrect',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 260,
      );
    } else if (e.code == 'user-not-found') {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Sign up first',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 260,
      );
    } else {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        title: 'Unknown Error, Please try again later',
        configuration: const IconConfiguration(icon: Icons.close),
        maxWidth: 300,
      );
    }
  }

  static Future<void> requestFollow(String uid, String targetUid) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(targetUid).get();
      List requests = (snap.data()! as dynamic)['requests'];

      if (!requests.contains(uid)) {
        await _firestore.collection('users').doc(targetUid).update({
          'requests': FieldValue.arrayUnion([uid])
        });
      } else {
        await _firestore.collection('users').doc(targetUid).update({
          'requests': FieldValue.arrayRemove([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Does backend work for user of UID uid to follow or unfollow another user of UID followId
  ///
  /// Both the following list for current user and followers list for target user gets modified
  static Future<void> followUser(String uid, String followId) async {
    // This is not a streambuilder which is always listening for changes
    // This is a Future
    // Therefore IT IS IMPORTANT to setState in order to update values
    // upon using the function
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
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

  /// Posts the diary to the followers of user of UID uid
  ///
  /// Goes through each follower in list of followers and adds the diary along
  /// with information about the poster into their homepage_feed collection
  static void postDiary(QueryDocumentSnapshot diary, String uid) async {
    try {
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("posts")
          .add({
        "diary_title": diary['diary_title'],
        "creation_date": diary['creation_date'],
        "diary_content": diary['diary_content'],
        "color_id": diary['color_id'],
        "poster_uid": _auth.currentUser!.uid,
        "post_date": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
        "24hr_expiry": true,
        "display_type": 'DIARYCARD',
        "creation_timestamp": Timestamp.now()
      }).then((value) {
        print(value.id);
      }).catchError((error) => print("error"));
      /*
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      var userData = userSnap.data()!;
      List followers = (userData as dynamic)['followers'];
      for (String follower in followers) {
        _firestore
            .collection("users")
            .doc(follower)
            .collection("homepage_feed")
            .add({
          "poster_profile_pic": userData['profilepic'],
          "poster_uid": uid,
          "poster_name": userData['username'],
          "diary_title": diary['diary_title'],
          "creation_date": diary['creation_date'],
          "diary_content": diary['diary_content'],
          "color_id": diary['color_id'],
        }).then((value) {
          print(value.id);
        }).catchError((error) => print("error"));
      } */
    } catch (e) {
      print(e.toString());
    }
  }

  static void postCard(var JSONcontent, String backgroundImage) {
    try {
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("posts")
          .add({
        "card_background": backgroundImage,
        "diary_content": JSONcontent,
        'display_type': 'WORDONLYDISPLAY',
        "poster_uid": _auth.currentUser!.uid,
        "post_date": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
        "24hr_expiry": true,
        "creation_timestamp": Timestamp.now()
      }).then((value) {
        print(value.id);
      }).catchError((error) => print("error"));
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<
      CombineLatestStream<QuerySnapshot<Map<String, dynamic>>,
          List<QuerySnapshot<Map<String, dynamic>>>>> getPosts(
      String uid) async {
    var userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userData = userSnap.data()!;
    List followings = (userData as dynamic)['following'];
    return CombineLatestStream.list<QuerySnapshot<Map<String, dynamic>>>(
        followings.map((following) => _firestore
                .collection("users")
                .doc(following)
                .collection("posts")
                .orderBy("creation_timestamp", descending: true)
                .snapshots()
            ));
  }
}
