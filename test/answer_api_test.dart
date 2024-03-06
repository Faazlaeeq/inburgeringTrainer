import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/repository/answer_repository.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('AnswerRepository', () {
    Dio dio = MockDio();
    AnswerRepository answerRepository = AnswerRepository(dio: dio);

    test('postAnswer returns correct data when response is 200', () async {
      final question = 'question';
      final answer = 'answer';
      final userID = 'userID';
      final url = PostApi.sendAnswerUrl;
      final data = {
        'question': question,
        'text': answer,
        'userID': userID,
      };
      final responseData = {
        'correction': 'correction',
        'input': 'input',
      };

      when(dio.post(
        url,
        options: anyNamed('options'),
        data: data,
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: url),
          ));

      final result =
          await answerRepository.postAnswer(question, answer, userID);

      expect(result, responseData);
    });

    test('postAnswer throws when response is not 200', () async {
      final question = 'question';
      final answer = 'answer';
      final userID = 'userID';
      final url = PostApi.sendAnswerUrl;
      final data = {
        'question': question,
        'text': answer,
        'userID': userID,
      };

      when(dio.post(
        url,
        options: anyNamed('options'),
        data: data,
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 400,
            requestOptions: RequestOptions(path: url),
          ));

      expect(() => answerRepository.postAnswer(question, answer, userID),
          throwsA(isA<Exception>()));
    });
  });
}
