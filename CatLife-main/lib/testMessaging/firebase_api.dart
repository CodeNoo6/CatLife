import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
  }
}
