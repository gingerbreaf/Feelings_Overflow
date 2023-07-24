import 'dart:convert';
import 'dart:math';

import 'package:feelings_overflow/design/diary_card.dart';
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
  myDiariesFeature();
}