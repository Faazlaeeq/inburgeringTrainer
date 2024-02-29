import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';

class ExerciseRepository {
  final Dio _dio = Dio();

  Future<List<ExerciseModel>> getUserExercises() async {
    debugPrint("requesting questions...");
    final response = await _dio.get(GetApi.listUserExcerciseUrl,
        options: Options(headers: {'x-api-key': Api.apiKey}),
        queryParameters: {
          'userID': 'fa7bad60-97fa-47e2-8791-f96107f62d49',
          'level': 'A2',
          'type': 'speaking'
        });
    debugPrint("Full Response:$response");

    final List<dynamic> exercises = response.data['exercises'];

    List<ExerciseModel> allSpeakingTests = [];

    for (var exercise in exercises) {
      final List<dynamic> speakingTests = exercise['speakingTests'];
      final String categoryName = exercise['category'];
      for (var test in speakingTests) {
        String jsonString = jsonEncode(test);
        debugPrint(jsonString);
        allSpeakingTests.add(ExerciseModel.fromJson(jsonString, categoryName));
      }
    }

    return allSpeakingTests;
  }
}
