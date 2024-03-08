import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/models/question_model.dart';
import 'package:inburgering_trainer/utils/myexceptions.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QuestionRepository {
  void writeResponseToFile(String data) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/response.txt');
    await file.writeAsString(data);
  }

  final Dio _dio = Dio();
  Future<List<QuestionModel>> getQuestions(
      {String? exerciseId, String? userId}) async {
    debugPrint("getting exercises..");
    try {
      List<QuestionModel> questions = [];
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final netStatus = await InternetHelper.checkInternetConnectivity();

      final List<dynamic>? cachedQues =
          await HiveHelper.getData(exerciseId.toString());

      if (netStatus) {
        if (cachedQues != null) {
          final res = await _dio.get(GetApi.listQuestionsUrl,
              options: Options(
                  headers: {
                    'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped',
                    'If-Modified-Since': formattedDate
                  },
                  validateStatus: (status) {
                    return status! < 400;
                  }),
              queryParameters: {
                'userID': userId ?? 'fa7bad60-97fa-47e2-8791-f96107f62d49',
                'excerciseID':
                    exerciseId ?? 'f655b6f1-f062-454f-856f-e8fdae372297',
              });

          if (res.statusCode == 304) {
            debugPrint('304 response');
            questions =
                cachedQues.map((item) => item as QuestionModel).toList();

            return questions;
          }
        }

        final response = await Dio().get(
          GetApi.listQuestionsUrl,
          options: Options(headers: {
            'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped'
          }),
          queryParameters: {
            'userID': userId ?? 'fa7bad60-97fa-47e2-8791-f96107f62d49',
            'excerciseID': exerciseId ?? 'f655b6f1-f062-454f-856f-e8fdae372297',
          },
        );
        questions = (response.data['exercises'] as List)
            .map((e) => QuestionModel.fromJson(e))
            .toList();
        await HiveHelper.saveData(exerciseId.toString(), questions);

        return questions;
      } else if (cachedQues != null) {
        questions = cachedQues.map((item) => item as QuestionModel).toList();
        return questions;
      } else {
        throw NoInternetException(
            message:
                "No Internet connection!\n\n This app need internet connection at first load to store exercises for offline usage.");
      }
    } catch (e) {
      debugPrint("Error from repo: $e");
      throw e;
    }
  }
}
