// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      // ignore: no_default_cases
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBbTai1B3qjjR3lV5w_Hx6vpQqnpD0Bxxo',
    appId: '1:487400574928:web:49ec711a0cc13b9c5533d5',
    messagingSenderId: '487400574928',
    projectId: 'henry-test-2',
    authDomain: 'henry-test-2.firebaseapp.com',
    databaseURL: 'https://henry-test-2.firebaseio.com',
    storageBucket: 'henry-test-2.appspot.com',
    measurementId: 'G-63G95996BW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAx4ktMVp4LP-3RlP9GRVz2VOEBySAJnek',
    appId: '1:487400574928:android:a024e48048903e645533d5',
    messagingSenderId: '487400574928',
    projectId: 'henry-test-2',
    databaseURL: 'https://henry-test-2.firebaseio.com',
    storageBucket: 'henry-test-2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDt9tGasjLYS4bm2JpQz8DTeJ78rRuSAYM',
    appId: '1:487400574928:ios:955273aa0855ce845533d5',
    messagingSenderId: '487400574928',
    projectId: 'henry-test-2',
    databaseURL: 'https://henry-test-2.firebaseio.com',
    storageBucket: 'henry-test-2.appspot.com',
    iosClientId:
        '487400574928-odfgo77foqdlhuj3o201nj67hct2rutg.apps.googleusercontent.com',
    iosBundleId: 'com.example.minChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDt9tGasjLYS4bm2JpQz8DTeJ78rRuSAYM',
    appId: '1:487400574928:ios:087372fee48cbef35533d5',
    messagingSenderId: '487400574928',
    projectId: 'henry-test-2',
    databaseURL: 'https://henry-test-2.firebaseio.com',
    storageBucket: 'henry-test-2.appspot.com',
    iosClientId:
        '487400574928-k3ae8l1dn2tis6hthome1el530anc52q.apps.googleusercontent.com',
    iosBundleId: 'com.example.minChat.RunnerTests',
  );
}
