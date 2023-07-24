import 'dart:math';

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


      /// Widget Test for Login / Registration
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
      const String emailUsed = 'test33@gmail.com';
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
  UnitTestFreshAccount();
}