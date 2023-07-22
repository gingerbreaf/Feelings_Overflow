/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

exports.sendPostNotification = functions.firestore
  .document('users/{userId}/posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId; // The user who created the post
    const postId = context.params.postId;

    // Get the array of followers' UIDs from the user document
    const userSnapshot = await admin.firestore().collection('users').doc(userId).get();
    const followers = userSnapshot.get('followers') as string[]; // Assuming you stored followers as an array of strings in the 'followers' field

    // Create a notification payload
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Post',
        body: 'A new post has been created!',
      },
      data: {
        postId: postId, // Add any additional data you want to send with the notification
      },
    };

    // Fetch the FCM tokens of followers
    const tokensSnapshot = await admin.firestore().collection('users').where('uid', 'in', followers).get();
    const tokenList = tokensSnapshot.docs.map(doc => doc.get('fcmToken') as string);

    // Send notifications to followers
    await admin.messaging().sendToDevice(tokenList, payload);
  });
