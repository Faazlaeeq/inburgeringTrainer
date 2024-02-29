import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/models/question_model.dart';

class QuestionRepository {
  Future<List<QuestionModel>> getQuestions(
      {String? exerciseId, String? userId}) async {
    debugPrint("getting exercises..");
    List<QuestionModel> questions = [];

    final response = await Dio().get(
      GetApi.listQuestionsUrl,
      options: Options(
          headers: {'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped'}),
      queryParameters: {
        'userID': userId ?? 'fa7bad60-97fa-47e2-8791-f96107f62d49',
        'excerciseID': exerciseId ?? 'f655b6f1-f062-454f-856f-e8fdae372297',
      },
    );
    questions = (response.data['questions'] as List)
        .map((e) => QuestionModel.fromJson(e))
        .toList();

    debugPrint(response.data);
    return questions;
  }
}
