import 'package:dio/dio.dart';
import 'package:inburgering_trainer/config/api.dart';

class ExerciseRepository {
  final Dio _dio = Dio();

  Future<Map> getUserExercises() async {
    final response = await _dio.get(
      'https://y3kq7n9xx7.execute-api.eu-west-3.amazonaws.com/gamma/api/langtools/listQuestions',
      options: Options(
          headers: {'x-api-key': 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped'}),
      queryParameters: {
        'userID': 'fa7bad60-97fa-47e2-8791-f96107f62d49',
        'excerciseID': 'f655b6f1-f062-454f-856f-e8fdae372297',
      },
    );
    print(response.data);
    return response.data;
  }

  Future<Map> getQuestions() async {
    print("requesting questions...");
    final response = await _dio.get(GetApi.listQuestionsUrl,
        options: Options(headers: {'x-api-key': Api.apiKey}),
        data: {
          'userID': 'fa7bad60-97fa-47e2-8791-f96107f62d49',
          'excerciseID': 'f655b6f1-f062-454f-856f-e8fdae372297',
        });
    print(response);
    return response.data;
  }
}
