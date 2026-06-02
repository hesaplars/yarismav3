import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFoQPV3kyha6k15VxHRJhIr8qjgvYjVeo',
    appId: '1:143964244900:web:fc2fa0222cddedeafc8f31',
    messagingSenderId: '143964244900',
    projectId: 'yarisma-live-e6281',
    authDomain: 'yarisma-live-e6281.firebaseapp.com',
    databaseURL: 'https://yarisma-live-e6281-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'yarisma-live-e6281.firebasestorage.app',
  );

  // TODO: Replace appId with the Android app id generated from Firebase Console.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFoQPV3kyha6k15VxHRJhIr8qjgvYjVeo',
    appId: '1:143964244900:android:replace-me',
    messagingSenderId: '143964244900',
    projectId: 'yarisma-live-e6281',
    databaseURL: 'https://yarisma-live-e6281-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'yarisma-live-e6281.firebasestorage.app',
  );

  // TODO: Add iOS if the app is shipped to iPhone later.
  static const FirebaseOptions ios = web;
}
