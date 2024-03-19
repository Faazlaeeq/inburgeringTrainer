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
    apiKey: 'AIzaSyC81pMMeFYIDzBqwIH08NOXJJw9GSmj0jU',
    appId: '1:117649696358:web:7acb01ff289272813d2fa7',
    messagingSenderId: '117649696358',
    projectId: 'language-bc37a',
    authDomain: 'language-bc37a.firebaseapp.com',
    storageBucket: 'language-bc37a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYtTWv6Pmb_lYbrIY9KXMd6t5-ejp6WAM',
    appId: '1:117649696358:android:3fca4b42ca5260a83d2fa7',
    messagingSenderId: '117649696358',
    projectId: 'language-bc37a',
    storageBucket: 'language-bc37a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDdOI6ZBTUNhdyN_uH4zgGRel-Q8a2GMqQ',
    appId: '1:117649696358:ios:3a593d8887c391703d2fa7',
    messagingSenderId: '117649696358',
    projectId: 'language-bc37a',
    storageBucket: 'language-bc37a.appspot.com',
    androidClientId: '117649696358-gvq7pt49pmq4i2jnlsfc5o4jga5e7sae.apps.googleusercontent.com',
    iosClientId: '117649696358-9ip26lm5gqrcpl1cp3gqdl5trq8pu08k.apps.googleusercontent.com',
    iosBundleId: 'com.example.inburgeringTrainer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDdOI6ZBTUNhdyN_uH4zgGRel-Q8a2GMqQ',
    appId: '1:117649696358:ios:10c852e0b83333043d2fa7',
    messagingSenderId: '117649696358',
    projectId: 'language-bc37a',
    storageBucket: 'language-bc37a.appspot.com',
    androidClientId: '117649696358-gvq7pt49pmq4i2jnlsfc5o4jga5e7sae.apps.googleusercontent.com',
    iosClientId: '117649696358-h0f55jjnl7gdi3k41m31n7cct3q7j741.apps.googleusercontent.com',
    iosBundleId: 'com.example.inburgeringTrainer.RunnerTests',
  );
}
