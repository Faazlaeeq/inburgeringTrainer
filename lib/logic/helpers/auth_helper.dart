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
}
