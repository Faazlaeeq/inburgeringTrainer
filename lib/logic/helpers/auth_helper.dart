// import 'package:dio/dio.dart';
// import 'package:inburgering_trainer/config/api.dart';
// import 'package:inburgering_trainer/utils/imports.dart';

// class AuthHelper {
//   static String userId = "80872066-9e71-4f03-8d31-a0f635b73112";
//   static String userId2 = "813d1149-73a9-4c6d-b0c5-1c7893da957d";
//   static String userIdDemo = "";

//   Future<bool> deleteUser() async {
//     Dio dio = Dio();

//     try {
//       var response = await dio.post(PostApi.deleteUserUrl,
//           data: {"userID": userId},
//           options: Options(headers: {'x-api-key': Api.apiKey2}));
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       return false;
//     }
//   }
// }
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class AuthHelper {
  static String userId = "80872066-9e71-4f03-8d31-a0f635b73112";
  static String userId2 = "813d1149-73a9-4c6d-b0c5-1c7893da957d";
  static String userIdDemo = "";

  Future<bool> deleteUser() async {
    Dio dio = Dio();

    try {
      var response = await dio.post(PostApi.deleteUserUrl,
          data: {"userID": userId},
          options: Options(headers: {'x-api-key': Api.apiKey}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> post() async {
    try {
      // await logout();
      final GoogleSignInAuthentication googleSignInAuth =
          await signInwithoutFirebase();
      final String? userGoogleToken = googleSignInAuth.idToken;

      debugPrint("faaz: $userGoogleToken");
      Dio dio = Dio();
      var response = await dio.post(PostApi.googleSignInUrl,
          data: {"token": userGoogleToken},
          options: Options(headers: {'x-api-key': Api.apiKey}));

      if (response.statusCode == 200) {
        final String userId = response.data['userId'];
        // Update userId in class
        AuthHelper.userId = userId;
        debugPrint("faaz: $userId");
      }
      debugPrint("faaz: $response, ${response.data}, ${response.statusCode}");
    } catch (e) {
      debugPrint("faaz: error from google signIn:$e");
    }
  }

  Future<GoogleSignInAuthentication> signInwithoutFirebase() async {
    //Default definition
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

//If current device is Web or Android, do not use any parameters except from scopes.
    if (kIsWeb || Platform.isAndroid) {
      googleSignIn = GoogleSignIn(
        clientId:
            "610943408715-met95o3h1120vbgf6ajp89m62g3p3i15.apps.googleusercontent.com",
        scopes: [
          'email',
        ],
      );
    }

//If current device IOS or MacOS, We have to declare clientID
//Please, look STEP 2 for how to get Client ID for IOS
    if (Platform.isIOS || Platform.isMacOS) {
      googleSignIn = GoogleSignIn(
        clientId: "YOUR_CLIENT_ID.apps.googleusercontent.com",
        scopes: [
          'email',
        ],
      );
    }

    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

//If you want further information about Google accounts, such as authentication, use this.
    final GoogleSignInAuthentication googleAuthentication =
        await googleAccount!.authentication;
    return googleAuthentication;
  }
  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<void> logout() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     // Reset userId in class
  //     AuthHelper.userId = "";
  //     debugPrint("User logged out successfully");
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}
