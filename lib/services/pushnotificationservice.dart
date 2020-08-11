import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // Called when app is in foreground and receives a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      // Called when app is closed and it's opened from push notification directly
      onLaunch: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      // Called when app is in backgroundd and it's opened from push notification
      onResume: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
    );
  }
}