class Api {
  static const String baseUrl =
      'https://y3kq7n9xx7.execute-api.eu-west-3.amazonaws.com/gamma/api/langtools';
  static const String apiKey = 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped';
}

class GetApi extends Api {
  static const String listUserExcercises = '/listUserExcercises';
  static const String listQuestions = '/listQuestions';
  static const String listUserExcerciseUrl = Api.baseUrl + listUserExcercises;
  static const String listQuestionsUrl = Api.baseUrl + listQuestions;
}
