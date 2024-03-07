import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/models/question_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QuestionRepository {
  void writeResponseToFile(String data) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/response.txt');
    await file.writeAsString(data);
  }

  Future<List<QuestionModel>> getQuestions(
      {String? exerciseId, String? userId}) async {
    debugPrint("getting exercises..");
    try {
      List<QuestionModel> questions = [];
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      HiveHelper.saveData("questionLastFetched", formattedDate);

      final response = await Dio().get(
        GetApi.listQuestionsUrl,
        options: Options(
            headers: {'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped'}),
        queryParameters: {
          'userID': userId ?? 'fa7bad60-97fa-47e2-8791-f96107f62d49',
          'excerciseID': exerciseId ?? 'f655b6f1-f062-454f-856f-e8fdae372297',
        },
      );
      writeResponseToFile(response.data.toString());
      print("going");
      print("Response from questionCubit ${response.data['exercises']}");
      questions = (response.data['exercises'] as List)
          .map((e) => QuestionModel.fromJson(e))
          .toList();

      return questions;
    } catch (e) {
      print("Error from cubit: $e");
      throw Exception(e);
    }
  }
}
