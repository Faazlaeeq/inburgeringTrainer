import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/logic/helpers/auth_helper.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';

class ExerciseRepository {
  final Dio _dio = Dio();

  Future<List<ExerciseModel>> getUserExercises() async {
    debugPrint("requesting questions...");
    final response = await _dio.get(GetApi.listUserExcerciseUrl,
        options: Options(headers: {'x-api-key': Api.apiKey}),
        queryParameters: {
          'userID': AuthHelper.userId,
          'level': 'A2',
          'type': 'speaking'
        });
    debugPrint("Full Response:$response");

    if (response.statusCode == 200) {
      final List<dynamic> exercises = response.data['exercises'];

      List<ExerciseModel> allSpeakingTests = [];

      for (var exercise in exercises) {
        final List<dynamic> speakingTests = exercise['speakingTests'];
        final String categoryName = exercise['category'];
        for (var test in speakingTests) {
          String jsonString = jsonEncode(test);
          debugPrint(jsonString);
          allSpeakingTests
              .add(ExerciseModel.fromJson(jsonString, categoryName));
        }
      }
      return allSpeakingTests;
    } else if (response.statusCode == 402) {
      throw Exception(response.data['message'] as String);
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<int> getTotalQuestions() async {
    final response = await _dio.get(GetApi.listUserExcerciseUrl,
        options: Options(headers: {'x-api-key': Api.apiKey}),
        queryParameters: {
          'userID': AuthHelper.userId,
          'level': 'A2',
          'type': 'speaking'
        });
    print(response.data['questionsCount'] as int);
    return response.data['questionsCount'] as int;
  }
}
