// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAfxbiV3KEiqPQzBl4CYmSDy9iarWivhYI',
    appId: '1:406830226277:web:efe9de70dfa9df1c069f8c',
    messagingSenderId: '406830226277',
    projectId: 'zenunni-dac3d',
    authDomain: 'zenunni-dac3d.firebaseapp.com',
    storageBucket: 'zenunni-dac3d.firebasestorage.app',
    measurementId: 'G-8FEX83KGGJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1fFJaJY44B3BEleM-IXNfZww3OyNY1H8',
    appId: '1:406830226277:android:4a15262d8780488d069f8c',
    messagingSenderId: '406830226277',
    projectId: 'zenunni-dac3d',
    storageBucket: 'zenunni-dac3d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGN7YAc97QMSDkhwsj7d-Lr7OjRb32CD0',
    appId: '1:406830226277:ios:f84498ba9a231e9c069f8c',
    messagingSenderId: '406830226277',
    projectId: 'zenunni-dac3d',
    storageBucket: 'zenunni-dac3d.firebasestorage.app',
    iosBundleId: 'com.example.zen',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGN7YAc97QMSDkhwsj7d-Lr7OjRb32CD0',
    appId: '1:406830226277:ios:f84498ba9a231e9c069f8c',
    messagingSenderId: '406830226277',
    projectId: 'zenunni-dac3d',
    storageBucket: 'zenunni-dac3d.firebasestorage.app',
    iosBundleId: 'com.example.zen',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfxbiV3KEiqPQzBl4CYmSDy9iarWivhYI',
    appId: '1:406830226277:web:7e2b4ef269026fdd069f8c',
    messagingSenderId: '406830226277',
    projectId: 'zenunni-dac3d',
    authDomain: 'zenunni-dac3d.firebaseapp.com',
    storageBucket: 'zenunni-dac3d.firebasestorage.app',
    measurementId: 'G-3ST94ELQ27',
  );
}
