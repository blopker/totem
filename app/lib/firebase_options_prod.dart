// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for $defaultTargetPlatform - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvqPYfwmzlGbZj6V0HzymJzeIA2unRPv8',
    appId: '1:35349008308:web:a6c7a15638b16df4206ce1',
    messagingSenderId: '35349008308',
    projectId: 'totem-26659',
    authDomain: 'totem-26659.firebaseapp.com',
    storageBucket: 'totem-26659.appspot.com',
    measurementId: 'G-V3C2V9LK3F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvqPYfwmzlGbZj6V0HzymJzeIA2unRPv8',
    appId: '1:35349008308:android:8be76d38d68eed40206ce1',
    messagingSenderId: '35349008308',
    projectId: 'totem-26659',
    storageBucket: 'totem-26659.appspot.com',
    androidClientId:
        '35349008308-0niklmq603bp7hopttpdc1amjhav36ue.apps.googleusercontent.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpI9GCefQGnGNYOjckHS-AuIy6lI2FlII',
    appId: '1:35349008308:ios:bd903a0a3c9a995b206ce1',
    messagingSenderId: '35349008308',
    projectId: 'totem-26659',
    storageBucket: 'totem-26659.appspot.com',
    iosClientId:
        '35349008308-f0i832q0bgd158ptsr8d68h2eb2purhd.apps.googleusercontent.com',
    iosBundleId: 'io.kbl.totem',
  );
}
