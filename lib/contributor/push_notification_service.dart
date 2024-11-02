import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _fcm.requestPermission();

    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification in foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened from background: ${message.notification?.title}");
    });
  }

  Future<void> sendNotificationToTopic(String title, String body, String topic) async {
    // Add code here to trigger a cloud function or API for sending FCM messages
  }
}
