import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions createOptions(
    String apiKey,
    String appId,
    String messagingSenderId,
    String projectId,
    String authDomain,
    String storageBucket,
    String measurementId,
    String androidClientId,
    String iosClientId,
    String iosBundleId,
  ) {
    return FirebaseOptions(
      
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
      measurementId: measurementId,
      androidClientId: androidClientId,
      iosClientId: iosClientId,
      iosBundleId: iosBundleId,
    );
  }

  static final FirebaseOptions web = createOptions(
    dotenv.env['FIREBASE_API_KEY']!,
    dotenv.env['FIREBASE_APP_ID']!,
    dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    dotenv.env['FIREBASE_PROJECT_ID']!,
    dotenv.env['FIREBASE_AUTH_DOMAIN']!,
    dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    dotenv.env['FIREBASE_MEASUREMENT_ID']!,
    '',
    '',
    '',
  );

  static final FirebaseOptions android = createOptions(
    dotenv.env['FIREBASE_API_KEY']!,
    dotenv.env['FIREBASE_APP_ID']!,
    dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    dotenv.env['FIREBASE_PROJECT_ID']!,
    '',
    '',
    '',
    '',
    '',
    '',
  );

  static final FirebaseOptions ios = createOptions(
    dotenv.env['FIREBASE_API_KEY']!,
    dotenv.env['FIREBASE_APP_ID']!,
    dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    dotenv.env['FIREBASE_PROJECT_ID']!,
    '',
    '',
    dotenv.env['FIREBASE_MEASUREMENT_ID']!,
    dotenv.env['FIREBASE_ANDROID_CLIENT_ID']!,
    dotenv.env['FIREBASE_IOS_CLIENT_ID']!,
    dotenv.env['FIREBASE_IOS_BUNDLE_ID']!,
  );

  static final FirebaseOptions macos = createOptions(
    dotenv.env['FIREBASE_API_KEY']!,
    dotenv.env['FIREBASE_APP_ID']!,
    dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    dotenv.env['FIREBASE_PROJECT_ID']!,
    '',
    '',
    dotenv.env['FIREBASE_MEASUREMENT_ID']!,
    dotenv.env['FIREBASE_ANDROID_CLIENT_ID']!,
    dotenv.env['FIREBASE_IOS_CLIENT_ID']!,
    dotenv.env['FIREBASE_IOS_BUNDLE_ID']!,
  );
}
