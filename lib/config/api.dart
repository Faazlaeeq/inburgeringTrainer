class Api {
  static const String baseUrl =
      'https://y3kq7n9xx7.execute-api.eu-west-3.amazonaws.com/gamma/api/langtools';
  static const String apiKey = 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped';
  static const String apiKey2 = 'xQ6kaLydnE536GH1z2j112ogpNsYqFXEWbTVzgNf';
  static const String baseUrl2 =
      "https://fli74i1oeh.execute-api.eu-west-3.amazonaws.com/prod/api/langtools/rectify";
}

class GetApi extends Api {
  static const String listUserExcercises = '/listUserExcercises';
  static const String listQuestions = '/listQuestions';
  static const String listUserExcerciseUrl = Api.baseUrl + listUserExcercises;
  static const String listQuestionsUrl = Api.baseUrl + listQuestions;
}
