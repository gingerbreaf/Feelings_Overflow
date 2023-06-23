import 'package:feelings_overflow/design/diary_card.dart';
import 'package:feelings_overflow/design/follow_button.dart';
import 'package:feelings_overflow/design/homepage_feed_diary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:feelings_overflow/main.dart' as app;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
List<String> followingUid = [];
List<String> followingName = [];
List<String> followingPicUrl = [];


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


void myDiariesFeature() {
  group('App test', (){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Core Feature my Diaries', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      /// Login test, should be able to login with correct credentials
      final emailFormField = find.byKey(const Key('login_email'));
      final passwordFormField = find.byKey(const Key('login_password'));
      final loginButton = find.byKey(const Key('login_gesture_detector'));

      await tester.enterText(emailFormField, 'gundamsean22@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      // At dashboard currently

      final myDiariesButton = find.byKey(const Key('my_diaries_tab'));
      await tester.tap(myDiariesButton);

      await Future.delayed(const Duration(seconds: 1));

      // At diaries page
      /// My Diaries Posting test, should be able to create and delete diaries
      final createDiariesButton = find.byType(FloatingActionButton);
      await tester.tap(createDiariesButton);
      await tester.pumpAndSettle();


      // At diary editor screen
      final titleField = find.byKey(const Key('diaries_title_text'));
      final contentField = find.byKey(const Key('diaries_content_text'));
      final createDiaryButton = find.byType(FloatingActionButton);

      await tester.enterText(titleField, 'Fall of the ROMAN empire');
      await tester.enterText(contentField, 'Et decorum est pro patria mori');
      await tester.pumpAndSettle();

      // Diary Creation
      await Future.delayed(const Duration(seconds: 3));
      await tester.tap(createDiaryButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));

      // Expect to find a matching diary entry
      expect(find.text('Fall of the ROMAN empire'), findsOneWidget);
      expect(find.text('Et decorum est pro patria mori'), findsOneWidget);

      // Wipe out diary entry
      final respectiveDiary = find.text('Fall of the ROMAN empire');

      // Diary reader screen
      await tester.tap(respectiveDiary);
      await tester.pumpAndSettle();

      final deleteDiaryButton = find.byType(FloatingActionButton);
      await tester.tap(deleteDiaryButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      final confirmDeleteButton = find.text('Yes Please');
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      expect(find.text('Fall of the ROMAN empire'), findsNothing);
      expect(find.text('Et decorum est pro patria mori'), findsNothing);


      /// If test is successful, core feature of offline personal diary posting
      /// and deletion is considered to be successful

    });
  });

}

void postingFeature() {
  group('App test 2',  (){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Core Features posting Feature', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      /// Login
      final emailFormField = find.byKey(const Key('login_email'));
      final passwordFormField = find.byKey(const Key('login_password'));
      final loginButton = find.byKey(const Key('login_gesture_detector'));

      await tester.enterText(emailFormField, 'gundamsean22@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      // By right we should be at the home page

      // Testing if we are at home page
      expect(find.text('Posts'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);

      /// Navigating through the posting UI and posting

      final createDiaryButton = find.byType(IconButton);
      await tester.tap(createDiaryButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Testing if we are at post reader screen
      final postPageTitle = find.text('Select a diary to post');
      expect(postPageTitle, findsOneWidget);

      await Future.delayed(const Duration(seconds: 1));

      // Clicking on a diary to select it to post
      final diaryTitle = find.text('test diary');
      expect(find.byType(DiaryCard), findsAtLeastNWidgets(1));
      await tester.tap(diaryTitle);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Check to see if we are at diary posting screen
      expect(diaryTitle, findsOneWidget);
      final diaryContent = find.text('12345');
      expect(diaryContent, findsOneWidget);
      final postDiaryButton = find.byKey(const Key('diary_post_button'));
      expect(postDiaryButton, findsOneWidget);
      await tester.tap(postDiaryButton);
      await tester.pumpAndSettle();
      // Successful diary post detected
      expect(find.text('Diary posted'), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1));
      // Back at home tab
      expect(find.text('Posts'), findsOneWidget);

      await tester.dragUntilVisible(
          diaryTitle,
          find.byType(GridView),
          const Offset(0, -250));
      await tester.pump();
      expect(diaryTitle, findsAtLeastNWidgets(1));
      expect(diaryContent, findsAtLeastNWidgets(1));



      /// Posting succeeded, all pages are where they ought to be throughout the
      /// process

    });
  });

}

void followFeature() {
  group('App test 3', (){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Core Features follow feature', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      /// Login
      final emailFormField = find.byKey(const Key('login_email'));
      final passwordFormField = find.byKey(const Key('login_password'));
      final loginButton = find.byKey(const Key('login_gesture_detector'));

      await tester.enterText(emailFormField, 'gundamsean22@gmail.com');
      await tester.enterText(passwordFormField, '12345678');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      // Navigate to profile page

      // At dashboard currently
      final myProfilePage = find.byKey(const Key('profile_tab'));
      await tester.tap(myProfilePage);
      await tester.pumpAndSettle();

      // At profile page currently
      final username = find.text('sk2001');
      final bio = find.text('Hey');
      final followerButton = find.widgetWithText(InkWell, 'Followers');
      final followingButton = find.widgetWithText(InkWell, 'Following');
      final post = find.widgetWithText(InkWell, 'Posts');


      // Widget testing for all the widgets in profile page
      expect(username, findsOneWidget);
      expect(bio, findsOneWidget);
      expect(followerButton, findsOneWidget);
      expect(followingButton, findsOneWidget);
      expect(post, findsOneWidget);

      // Heading to the following page (Search page)
      await tester.tap(followingButton);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      // Should be able to see who is your current Following
      getFollowing();

      // Ensure that the list of following is correct
      for (String name in followingName) {
        await tester.dragUntilVisible(
            find.text(name),
            find.byType(ListView),
            const Offset(0, -250));
        await tester.pumpAndSettle();
        expect(find.text(name), findsOneWidget);
      }

      // Searching
      final searchbar = find.byType(TextFormField);
      await tester.enterText(searchbar, 'jiangbw2001');
      await Future.delayed(const Duration(seconds: 2));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // selecting the right name
      final searchTile = find.byType(ListTile);
      expect(searchTile, findsAtLeastNWidgets(1));
      final searchName = find.text('jiangbw2001').first;
      expect(searchName, findsAtLeastNWidgets(1));

      // heading into the profile
      await tester.tap(searchName);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      // Into the other profile
      final appBar = find.byType(AppBar);
      final followButton = find.byType(FollowButton);
      final followButtonText = find.text('Follow');


      // Separating factor from profile tab
      expect(appBar, findsAtLeastNWidgets(1));
      // Havent yet follow the user, should display follow button first
      expect(followButtonText, findsAtLeastNWidgets(1));

      // This is a manual input for uid because we cant access it easily
      const uidUser = 'JQLG7fijiDYqvbXdZMUi6iBpN0G2';
      final expectedFollowerCount = await getFollowersCount(uidUser);
      final expectedFollowingCount = await getFollowingCount(uidUser);
      // Should have right number of followers and following
      expect(find.text(expectedFollowerCount), findsAtLeastNWidgets(1));
      expect(find.text(expectedFollowingCount), findsAtLeastNWidgets(1));

      // Follow user
      await tester.tap(followButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      // Button should change to unfollow
      final followButtonTextAfter = find.text('Unfollow');
      expect(followButtonTextAfter, findsAtLeastNWidgets(1));

      // user count should change
      final newFollowerCount = (int.parse(expectedFollowerCount) + 1).toString();
      expect(find.text(newFollowerCount), findsAtLeastNWidgets(1));
      expect(find.text(expectedFollowingCount), findsAtLeastNWidgets(1));


      //Reset to default position going into test
      await tester.tap(followButton);
      await tester.pumpAndSettle();

      //Back button on the appBar
      final backButton = find.byTooltip('Back');
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await Future.delayed(const Duration(seconds: 2));

    });
  });
}




void main() {
  followFeature();
}
