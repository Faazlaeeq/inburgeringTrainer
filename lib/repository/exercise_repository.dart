import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:inburgering_trainer/models/exersiceModel.dart';

class ExerciseRepository {
  final Dio _dio = Dio();

  Future<Map> getUserExercises() async {
    debugPrint("getting exercises");
    final response2 = await Dio().get(
      'https://y3kq7n9xx7.execute-api.eu-west-3.amazonaws.com/gamma/api/langtools/listQuestions',
      options: Options(
          headers: {'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped'}),
      queryParameters: {
        'userID': 'fa7bad60-97fa-47e2-8791-f96107f62d49',
        'excerciseID': 'f655b6f1-f062-454f-856f-e8fdae372297',
      },
    );

    print(response2.data);
    return response2.data;
  }

  // import 'dart:convert';

  Future<List<ExerciseModel>> getQuestions() async {
    print("requesting questions...");
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
    // debugPrint("Speaking Test: $allSpeakingTests");

    return allSpeakingTests;
    // final Map<String, dynamic> speakingTests =
    //     response.data['exercises']['speakingTests'];
    // List<ExerciseModel> exercises = [];
    // print("SpeakingTest: $speakingTests");
    // speakingTests.forEach((key, value) {
    //   print("Value from loop: $value");
    //   exercises.add(ExerciseModel.fromJson(value));
    // });

    // return exercises;
  }
}
