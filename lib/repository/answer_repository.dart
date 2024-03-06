// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import 'package:inburgering_trainer/config/api.dart';

class AnswerRepository {
  final Dio _dio = Dio();

  Future<Map<String, String>> postAnswer(
      String question, String answer, String userID) async {
    final url = PostApi.sendAnswerUrl;
    final data = {
      'question': question,
      'text': answer,
      'userID': userID,
    };

    final response = await _dio.post(url,
        options: Options(headers: {'x-api-key': Api.apiKey2}), data: data);
    if (response.statusCode == 200) {
      final responseData = response.data;
      print(responseData);
      return {
        'correction': responseData['correction'],
        'input': responseData['input'],
      };
    } else {
      throw Exception('Failed to post answer');
    }
  }
}