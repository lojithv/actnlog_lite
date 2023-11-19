// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9YnywWRyrD1PjDGxXxvvvCAhCHBuFNvs',
    appId: '1:189945015099:web:79b22889da73820321a51e',
    messagingSenderId: '189945015099',
    projectId: 'actnlog-lite',
    authDomain: 'actnlog-lite.firebaseapp.com',
    storageBucket: 'actnlog-lite.appspot.com',
    measurementId: 'G-D6BNQN9DLQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVJUuQ_nqWUz1-0mNWsOmPEjXBWG-2_Ns',
    appId: '1:189945015099:android:42518b63d0bc2fff21a51e',
    messagingSenderId: '189945015099',
    projectId: 'actnlog-lite',
    storageBucket: 'actnlog-lite.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1zCO9K6RyEgl8ZEzSmuLTK5QGoEKhwMU',
    appId: '1:189945015099:ios:9a0117fef20314b621a51e',
    messagingSenderId: '189945015099',
    projectId: 'actnlog-lite',
    storageBucket: 'actnlog-lite.appspot.com',
    iosClientId: '189945015099-9jslc72njgo39eiapmm32vbaah0s8v9n.apps.googleusercontent.com',
    iosBundleId: 'com.example.actnlogLite',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1zCO9K6RyEgl8ZEzSmuLTK5QGoEKhwMU',
    appId: '1:189945015099:ios:0d8898595692e1bb21a51e',
    messagingSenderId: '189945015099',
    projectId: 'actnlog-lite',
    storageBucket: 'actnlog-lite.appspot.com',
    iosClientId: '189945015099-066c0n208aed4b0u0cncs0t9flpbptd0.apps.googleusercontent.com',
    iosBundleId: 'com.example.actnlogLite.RunnerTests',
  );
}
