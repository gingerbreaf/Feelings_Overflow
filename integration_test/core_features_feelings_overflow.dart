import 'dart:convert';
import 'dart:math';

import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/design/follow_button.dart';
import 'package:feelings_overflow/design/font_cards.dart';
import 'package:feelings_overflow/design/homepage_feed_diary_card.dart';
import 'package:feelings_overflow/design/snip_UI_display_words_only.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feelings_overflow/main.dart' as app;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

String defaultpic = 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
/// List of user variables on Firebase under collection 'users'
String bio = '';
String email = '';
List<dynamic> followers = [];
List<dynamic> following = [];
String picUrl = 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
List<dynamic> requests = [];
String uid = '';
String username = '';

/// List that contain variables for your following
///
/// Used for profile testing
List<String> followingUid = [];
List<String> followingName = [];
List<String> followingPicUrl = [];

/// Get the data for the collection 'users' from firebase
getData(String uidUsed) async {
  try {
    // user data
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uidUsed)
        .get();


    var userData = userSnap.data()!;
    bio = userData['bio'];
    email = userData['email'];
    followers = userData['followers'];
    following = userData['following'];
    picUrl = userData['profilepic'];
    requests = userData['requests'];
    uid = userData['uid'];
    username = userData['username'];
    print('bio: $bio, email: $email, followers: $followers, following: $following' +
    ' picurl: $picUrl, requests: $requests, uid: $uid, username: $username');


  } catch (e) {
    print(e);
  }

}

verifyHomeDiary(String title, var JSONsubmitted) async {
  try{
    // post data
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('personal_diaries')
        .get();

    for (var docs in documentSnapshot.docs){
      var diary_data = docs.data()!;
      String diary_title = diary_data['diary_title'];
      var json = diary_data['diary_content'];
      expect(title, equals(diary_title));
    }
    //expect(json, equals(JSONsubmitted));

  }catch (e) {
    print(e);
  }
}

verifyDeletion() async {
  try {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('personal_diaries')
        .get();
    expect(documentSnapshot.docs.isEmpty, isTrue);
  } catch (e) {
    print(e);
  }

}

Future<String> getUsername(String uid) async {
  var userSnap = await _firestore.collection('users').doc(uid).get();
  var userData = userSnap.data()!;
  return userData['username'];
}

Future<String> getPicUrl(String uid) async {
  var userSnap = await _firestore.collection('users').doc(uid).get();
  var userData = userSnap.data()!;
  return userData['profilepic'];
}

Future<String> getFollowersCount(String uid) async {
  var userSnap = await _firestore.collection('users').doc(uid).get();
  var userData = userSnap.data()!;
  return userData['followers'].length.toString();
}


Future<String> getFollowingCount(String uid) async {
  var userSnap = await _firestore.collection('users').doc(uid).get();
  var userData = userSnap.data()!;
  return userData['following'].length.toString();
}

Future<int> getPostCount(String uid) async {
  var userSnap = await _firestore.collection('users').doc(uid).collection('posts').get();
  int userData = userSnap.size;
  return userData;
}


void getFollowing() async {
  try {
    var userSnap = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    var userData = userSnap.data()!;
    followingUid =
        (userData['following'] as List).map((e) => e as String).toList();
    for (String uid in followingUid) {
      String name = await getUsername(uid);
      followingName.add(name);
      String picUrl = await getPicUrl(uid);
      followingPicUrl.add(picUrl);
    }
  } catch (e) {
    print(e);
  }
}

verifyRequest() async {
  try {
    var userSnap = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var userData = userSnap.data()!;
    int requestLength = (userData['requests'] as List).length;
    expect(requestLength - requests.length == 1, isTrue);
  } catch (e) {
    print(e);
  }
}

verifyDerequest() async {
  try {
    var userSnap = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var userData = userSnap.data()!;
    int requestLength = (userData['requests'] as List).length;
    expect(requestLength == requests.length, isTrue);
  } catch (e) {
    print(e);
  }
}

verifyMyDiariesCount(int expectedCount) async {
  try{
    var userSnap = await _firestore.collection('users').doc(uid).collection('personal_diaries').get();
    int userData = userSnap.size;
    // There should only exist 1 diary
    expect(userData == expectedCount, isTrue);
  }catch (e) {
    print(e);
  }
}



/// Integration test for creating Diaries, editing and deleting
///
/// This is done in the My_Diaries Tab
void Login() {
  group('Core functionality test', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Login', (WidgetTester tester) async {
      // Launching App
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));


      /// Widget Test for Login
      // Finding the Image on screen
      expect(find.byKey(const Key('Logo')), findsOneWidget);


      //Finding the Text on screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Continue jotting it down!'), findsOneWidget);


      // Searching for the two available login field, email and password
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      expect(emailFormField, findsOneWidget);
      expect(passwordFormField, findsOneWidget);

      // Searching for the login button and register button
      final loginButton = find.byKey(const Key('login_gesture_detector'));
      final registerNowButton = find.byType(TextButton);
      expect(loginButton, findsOneWidget);
      expect(registerNowButton, findsOneWidget);
      expect(find.text('Not a member?'), findsOneWidget);

      /// Field Inputs, Unit Testing Login

      // Not inputting any fields
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Please fill in your particulars'), findsOneWidget);

      // Putting only a invalid email and clicking
      await tester.enterText(emailFormField, 'a');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Please fill in your particulars'), findsOneWidget);

      // Inputting both a invalid email and password
      await tester.enterText(emailFormField, 'a');
      await tester.pumpAndSettle();
      await tester.enterText(passwordFormField, '1');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Invalid email'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));


      // Inputting a email not registered
      await tester.enterText(emailFormField, 'testtest123@gmail.com');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Sign up first'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));



      // Inputting a email not registered and password
      await tester.enterText(emailFormField, 'testtest12345@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Sign up first'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));


      // Inputting a valid email that is registered but wrong password
      await tester.enterText(emailFormField, 'test223@gmail.com');
      await tester.enterText(passwordFormField, '1234');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Password Incorrect'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 3));


      // Inputting the right password and email
      await tester.enterText(emailFormField, 'test223@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      /// Widget Testing for Home Page

      // Should enter home page

      // Finding title
      expect(find.text('Posts'), findsOneWidget);
      // Finding plus to post Icon
      expect(find.byType(IconButton), findsOneWidget);
      // Finding home tab
      expect(find.text('Home'), findsOneWidget);
      // Finding search tab
      expect(find.text('Search'), findsOneWidget);
      // Finding My Diaries tab
      expect(find.text('My Diaries'), findsOneWidget);
      // Finding Profile tab
      expect(find.text('Profile'), findsOneWidget);

      String currentUserUid = _auth.currentUser!.uid;
      await getData(currentUserUid);





    }
    );
  });
}

void Register() {
  group('Core functionality test Registration', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Register', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 5));
      // We will skip what we test for the login page and head for the register screen
      final registerNowButton = find.byType(TextButton);
      await tester.tap(registerNowButton);
      await tester.pumpAndSettle(Duration(seconds: 5));


      /// Widget Testing for Register Screen

      // Finding the logo image
      expect(find.byKey(const Key('RegisterAppIconImage')), findsOneWidget);
      expect(find.text('Hello There'), findsOneWidget);
      expect(find.text('Register below with your details!'), findsOneWidget);

      // Finding the four text fields that exist
      final emailFormField = find.byKey(const Key('registerEmail'));
      final passwordFormField = find.byKey(const Key('registerPassword'));
      final confirmPasswordFormField = find.byKey(const Key('registerConfirmPassword'));
      final usernameFormField = find.byKey(const Key('registerUsername'));

      expect(emailFormField, findsOneWidget);
      expect(passwordFormField, findsOneWidget);
      expect(confirmPasswordFormField, findsOneWidget);
      expect(usernameFormField, findsOneWidget);

      // Sign up button
      final signUpButton = find.byKey(const Key('registerButton'));
      final loginPageButton = find.byType(TextButton);

      expect(signUpButton, findsOneWidget);
      expect(loginPageButton, findsOneWidget);

      /// Field Inputs, Unit Testing Register

      // Signing up with no details
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Signing up with everything but invalid email
      await tester.enterText(emailFormField, 'a');
      await tester.pumpAndSettle();
      await tester.enterText(passwordFormField, '1');
      await tester.pumpAndSettle();
      await tester.enterText(confirmPasswordFormField, '1');
      await tester.pumpAndSettle();
      await tester.enterText(usernameFormField, 's');
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Invalid email'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 3));


      // Signing up with a password of insufficient length
      await tester.enterText(emailFormField, 'tester23@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordFormField, '1');
      await tester.pumpAndSettle();
      await tester.enterText(confirmPasswordFormField, '1');
      await tester.pumpAndSettle();
      await tester.enterText(usernameFormField, 'Tammy');
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Weak Password'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 4));

      // Entering a email already registered
      await tester.enterText(emailFormField, 'tester3@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.enterText(confirmPasswordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.enterText(usernameFormField, 'This is sparta');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Email already in use'), findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Registering a email successfully
      // Do note that the account has to be deleted off firebase or
      // use another email in order to redo the test
      // TODO: change email before testing
      const String emailUsed = 'test334@gmail.com';
      const String usernameUsed = 'Tammy';


      await tester.enterText(emailFormField, emailUsed);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.enterText(confirmPasswordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.enterText(usernameFormField, usernameUsed);
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      /// Widget Testing for Home Page

      // Should enter home page

      // Finding title
      expect(find.text('Posts'), findsOneWidget);
      // Finding plus to post Icon
      expect(find.byType(IconButton), findsOneWidget);
      // Finding home tab
      expect(find.text('Home'), findsOneWidget);
      // Finding search tab
      expect(find.text('Search'), findsOneWidget);
      // Finding My Diaries tab
      expect(find.text('My Diaries'), findsOneWidget);
      // Finding Profile tab
      expect(find.text('Profile'), findsOneWidget);

      /// Unit Testing (ensuring details of user on firebase is correct)
      ///
      /// Same as UnitTestFreshAccount
      String currentUserUid = _auth.currentUser!.uid;
      await getData(currentUserUid);
      expect(email, equals(emailUsed));
      expect(username, equals(usernameUsed));
      expect(uid, equals(currentUserUid));
      expect(picUrl, equals(defaultpic));
      expect(followers.isEmpty, isTrue);
      expect(following.contains(currentUserUid), isTrue);
      expect(requests.isEmpty, isTrue);
      expect(bio, '');



    });
  });
}

void UnitTestFreshAccount() {
  group('Unit Testing for Registration', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Unit Testing new account', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byKey(const Key('login_gesture_detector'));

      await tester.enterText(emailFormField, 'test223@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));


      String currentUserUid = _auth.currentUser!.uid;
      await getData(currentUserUid);
      expect(email, 'test223@gmail.com');
      expect(username, 'Tammy');
      expect(uid, equals(currentUserUid));
      expect(picUrl, equals(defaultpic));
      expect(followers.isEmpty, isTrue);
      expect(following.contains(currentUserUid), isTrue);
      expect(requests.isEmpty, isTrue);
      expect(bio, '');

    });
  });

}

void myDiariesFeature() {
  group('App test', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Core Feature my Diaries', (tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 5));

      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byKey(const Key('login_gesture_detector'));

      await tester.enterText(emailFormField, 'test223@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));


      // At home page / dashboard currently

      final myDiariesButton = find.byKey(const Key('My Diaries'));
      await tester.tap(myDiariesButton);
      await tester.pumpAndSettle(Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 1));


      /// Widget Testing for My Diaries page
      final createDiariesButton = find.byType(FloatingActionButton);
      expect(createDiariesButton, findsOneWidget);
      expect(find.text('My Diaries'), findsAtLeastNWidgets(2));
      expect(find.text("You have no diaries. Create a new one!"), findsOneWidget);


      // At diaries page
      /// My Diaries Posting test, should be able to create, edit and delete diaries
      await tester.tap(createDiariesButton);
      await tester.pumpAndSettle(Duration(seconds: 5));


      final titleField = find.byKey(const Key('diaries_title_text'));
      final contentField = find.byKey(const Key('Quill_Editor'));
      final boldButton = find.byKey(const Key('Bold button'));
      final italicButton = find.byKey(const Key('Italic button'));
      final underlineButton = find.byKey(const Key('underline'));
      final createDiaryButton = find.byType(FloatingActionButton);


      String titleInput = 'Fall of the ROMAN empire';
      // Enter text into the title field
      await tester.enterText(titleField, titleInput);
      await tester.pumpAndSettle();



      // Get the QuillEditor widget and its controller
      final QuillEditor editorWidget = tester.widget(contentField) as QuillEditor;
      final QuillController controller = editorWidget.controller;

      // Compose the delta and set it to the QuillEditor controller
      final delta = Delta()..insert('Do you feel the same about rain today :)?', Style().toJson()); // 'i': true represents italic style
      controller.document.compose(delta, ChangeSource.LOCAL);

      var JSONsubmitted = jsonEncode(controller.document.toDelta().toJson());


      await tester.tap(contentField);
      await tester.pumpAndSettle();

      controller.updateSelection(TextSelection(baseOffset: 27, extentOffset: 43), ChangeSource.LOCAL);

      // Tap italic words to apply formatting
      await tester.tap(italicButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      controller.updateSelection(TextSelection(baseOffset: 27, extentOffset:31), ChangeSource.LOCAL);

      // Applying bold words to another selection
      await tester.tap(boldButton);
      await tester.pumpAndSettle(Duration(seconds: 15));

      // Diary creation
      await tester.tap(createDiaryButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      /// Unit Testing for diary creation
      await verifyHomeDiary(titleInput, JSONsubmitted);


      // Back to My Diary Screen
      /// Widget Testing after creation of the existence of diary card

      expect(find.text('Fall of the ROMAN empire'), findsOneWidget);
      expect(find.byType(DiaryCard), findsAtLeastNWidgets(1));


      // Finding the right diary card
      final respectiveDiary = find.text('Fall of the ROMAN empire');

      // Diary reader screen
      await tester.tap(respectiveDiary);
      await tester.pumpAndSettle(Duration(seconds: 3));



      final editContentField = find.byKey(const Key('Quill_Editor2'));
      // Get the QuillEditor widget and its controller
      final QuillEditor editorWidget2 = tester.widget(editContentField) as QuillEditor;
      final QuillController controller2 = editorWidget2.controller;

      //Editing the diary
      final delta2 = Delta()..insert('Oh I love it ', Style().toJson()); // 'i': true represents italic style
      controller2.document.compose(delta2, ChangeSource.LOCAL);

     await tester.tap(editContentField);
     await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(DiaryCard), findsAtLeastNWidgets(1));

      await tester.tap(respectiveDiary);
      await tester.pumpAndSettle(Duration(seconds: 3));


      final deleteDiaryButton = find.byType(FloatingActionButton);
      await tester.tap(deleteDiaryButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final confirmDeleteButton = find.text('Yes Please');
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      expect(find.text('Fall of the ROMAN empire'), findsNothing);
      await verifyDeletion();


    });
  });

}

void followFeature() {
  group('Follow & Unfollow Core Feature', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Testing the search, request and follow feature', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byKey(const Key('login_gesture_detector'));


      await tester.enterText(emailFormField, 'test223@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));
      await getData(_auth.currentUser!.uid);

      final searchButton = find.byKey(const Key('Search'));
      await tester.tap(searchButton);
      await tester.pumpAndSettle(Duration(seconds: 5));



      /// Widget testing for search page
      expect(find.text('Follow Requests'), findsOneWidget);
      expect(find.text('Follow requests will appear here'), findsOneWidget);

      final searchBar = find.byType(TextFormField);
      expect(searchBar, findsOneWidget);

      // Searching a known username
      await tester.enterText(searchBar, 'sk2001');
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      /// Widget Test for search bar
      final searchTile = find.byType(ListTile);
      expect(searchTile, findsAtLeastNWidgets(1));
      final searchName = find.text('sk2001').first;
      expect(searchName, findsAtLeastNWidgets(1));

      // heading into the profile
      await tester.tap(searchName);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final followButton = find.byType(FollowButton);
      final followButtonText = find.text('Follow');

      const uidUser = 'zNIejO3ZhjcK5Vujn9hDvQf1i7M2';

      /// Widget testing for other people's profile page
      ///
      /// Unit testing at the same time for the right data
      final expectedFollowerCount = await getFollowersCount(uidUser);
      final expectedFollowingCount = await getFollowingCount(uidUser);
      // Should have right number of followers and following
      expect(find.text(expectedFollowerCount), findsAtLeastNWidgets(1));
      expect(find.text(expectedFollowingCount), findsAtLeastNWidgets(1));

      // Follow user
      await tester.tap(followButton);
      await tester.pumpAndSettle(Duration(seconds: 1));

      /// Widget testing for follow button / request button
      // Button should change to request sent
      final followButtonTextAfter = find.text('Request Sent');
      expect(followButtonTextAfter, findsAtLeastNWidgets(1));
      /// Unit testing for requesting a follow
      await verifyRequest();

      await tester.tap(followButtonTextAfter);
      await tester.pumpAndSettle(Duration(seconds: 1));
      // Button should change back to follow
      expect(followButtonText, findsOneWidget);
      /// Unit testing for stopping a request
      await verifyDerequest();



    });
  });

}

void postingFeature() {
  group('App Test', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Posting Feature Integration Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Logging in
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byKey(const Key('login_gesture_detector'));


      // Email we will be using will not be test223@gmail.com
      // Will be another account in order to prevent failure in my diaries
      // integration test. This account should come with a ready made post
      await tester.enterText(emailFormField, 'test311@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      /// Unit Test for checking post entry
      int beforePostCount = await getPostCount(_auth.currentUser!.uid);


      // We will skip widget testing of home screen as its already done
      // in Login and Registration Integration Test
      final addPostButton = find.byType(IconButton);
      await tester.tap(addPostButton);
      await tester.pumpAndSettle(Duration(seconds: 2));


      /// Widget Test for new Post Screen
      
      expect(find.text('Select a diary to post'), findsOneWidget);

      // The title should be a constant
      final Diary = find.text('The night when it dies');
      expect(Diary, findsOneWidget);
      
      /// Unit Testing & Widget Test, verifying the number of diaries we have
      ///
      /// Should only have 1 count since its a pre-set account with 1 diary
      verifyMyDiariesCount(1);
      // We should find one diary card in existence to post
      expect(find.byType(DiaryCard), findsOneWidget);

      await tester.tap(Diary);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // In the diary_posting screen
      /// Widget test for diary_posting screen

      final richTextDisplay = find.byKey(const Key('finalPostingScreenEditor'));
      final snip = find.byKey(const Key('snip'));
      final post = find.byKey(const Key('postStraight'));

      expect(richTextDisplay, findsOneWidget);
      expect(snip, findsOneWidget);
      expect(post, findsOneWidget);

      // We going to do post first
      await tester.tap(post);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Diary posted'), findsOneWidget);

      // Back at home page
      /// Widget Testing for home page after post

      final homepageDiaryCard = find.byType(HomePageDiaryCard);
      expect(homepageDiaryCard, findsAtLeastNWidgets(1));

      /// Unit Test for checking post entry
      int afterPostCount = await getPostCount(_auth.currentUser!.uid);
      // the post count should go up by one
      expect(afterPostCount - beforePostCount == 1, isTrue);

      // Tap into profile screen
      final profile = find.text('Profile');
      await tester.tap(profile);
      await tester.pumpAndSettle();

      /// Widget Testing for profile page display
      // We should have 1 additional post in our display + post count going up
      final profilePostCard = find.byType(DiaryCard);
      expect(profilePostCard, findsAtLeastNWidgets(1));

      expect(find.text(afterPostCount.toString()), findsAtLeastNWidgets(1));


    });
  });

}

void snippetFeature() {
  group('Snipping Feature Test', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Snipping Feature Integration Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Logging in
      final emailFormField = find.byType(TextField).first;
      final passwordFormField = find.byType(TextField).last;
      final loginButton = find.byKey(const Key('login_gesture_detector'));


      // Email we will be using will not be test223@gmail.com
      // Will be another account in order to prevent failure in my diaries
      // integration test. This account should come with a ready made post
      await tester.enterText(emailFormField, 'test311@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));


      /// Unit Test for checking post entry
      int beforePostCount = await getPostCount(_auth.currentUser!.uid);

      print(beforePostCount);


      final Diary = find.text('The night when it dies');

      // Going to do snippets
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(Diary);
      await tester.pumpAndSettle(Duration(seconds: 2));

      final richTextDisplay = find.byKey(const Key('finalPostingScreenEditor'));
      final snip = find.byKey(const Key('snip'));
      final post = find.byKey(const Key('postStraight'));

      // Selecting words
      // Get the QuillEditor widget and its controller
      final QuillEditor editorWidget = tester.widget(richTextDisplay) as QuillEditor;
      final QuillController controller = editorWidget.controller;
      controller.updateSelection(TextSelection(baseOffset: 0, extentOffset: 42), ChangeSource.LOCAL);

      await tester.tap(snip);
      await tester.pumpAndSettle(Duration(seconds: 3));

      /// Widget test for snippet screen

      // Find at least 4 font cards
      expect(find.byType(FontCard), findsAtLeastNWidgets(4));
      final fontCard1 = find.byKey(const Key('font_1'));
      final fontCard2 = find.byKey(const Key('font_2'));
      final fontCard3 = find.byKey(const Key('font_3'));
      final fontCard4 = find.byKey(const Key('font_4'));

      final background1 = find.byKey(const Key('background_1'));
      final background2 = find.byKey(const Key('background_2'));
      final background3 = find.byKey(const Key('background_3'));
      final background4 = find.byKey(const Key('background_4'));

      final formatText = find.byKey(const Key('format_font'));

      final postButton = find.byType(FloatingActionButton);


      await tester.tap(fontCard1);
      await tester.tap(background1);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(formatText);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(fontCard2);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(formatText);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(fontCard3);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(formatText);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(fontCard4);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(formatText);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(background2);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(background3);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.dragUntilVisible(background4, find.byKey(const Key('background_scroll')), const Offset(-200, 100));
      await tester.tap(background4);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(fontCard3);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(formatText);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(postButton);
      await tester.pumpAndSettle(Duration(seconds: 2));

      /// Widget testing for home page after posting
      final card = find.byType(WordOnlyDisplay);
      expect(card, findsAtLeastNWidgets(1));

      /// Unit Test for checking post entry
      int afterPostCount = await getPostCount(_auth.currentUser!.uid);
      print(afterPostCount);
      // the post count should go up by one
      expect(afterPostCount - beforePostCount == 1, isTrue);

      // Tap into profile screen
      final profile = find.text('Profile');
      await tester.tap(profile);
      await tester.pumpAndSettle();

      /// Widget Testing for profile page display
      // We should have 1 additional post in our display + post count going up
      final profilePostCard = find.byType(DiaryCard);
      expect(profilePostCard, findsAtLeastNWidgets(1));

      expect(find.text(afterPostCount.toString()), findsAtLeastNWidgets(1));






    });
  });

}




/*
void template() {
  group('Unit Testing for Registration', (){
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Unit Testing new account', (WidgetTester tester) async {
        app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });

}

 */


void main() {
  postingFeature();
}