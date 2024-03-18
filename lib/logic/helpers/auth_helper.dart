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
import 'package:firebase_auth/firebase_auth.dart';
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
          options: Options(headers: {'x-api-key': Api.apiKey2}));
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
      await logout();
      final UserCredential userCredential = await signInWithGoogle();

      final String? userGoogleToken = await userCredential.user!.getIdToken();
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Reset userId in class
      AuthHelper.userId = "";
      debugPrint("User logged out successfully");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
