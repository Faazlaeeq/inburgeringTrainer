class Api {
  // static const String baseUrl =
  //     'https://y3kq7n9xx7.execute-api.eu-west-3.amazonaws.com/gamma/api/langtools';
  static const String baseUrl =
      'https://fli74i1oeh.execute-api.eu-west-3.amazonaws.com/prod/api/langtools';

  // static const String apiKey = 'hlXOI5TUFzqrDEWUAc424S0LUrfqBWA6Uxehtped';
  static const String apiKey = 'xQ6kaLydnE536GH1z2j112ogpNsYqFXEWbTVzgNf';
  static const String apiKey2 = 'xQ6kaLydnE536GH1z2j112ogpNsYqFXEWbTVzgNf';

  static const String baseUrl2 =
      "https://fli74i1oeh.execute-api.eu-west-3.amazonaws.com/prod/api/langtools";
}

class PostApi extends Api {
  static const String sendAnswer = "/rectify";
  static const String sendAnswerUrl = Api.baseUrl2 + sendAnswer;
  static const String deleteUser = "/googleLogin";
  static const String deleteUserUrl = Api.baseUrl2 + deleteUser;
  static const String sendTranscript = "/transcribe";
  static const String sendTranscriptUrl = Api.baseUrl + sendTranscript;

  static const String googleSignIn = "/googleLogin";
  static const String googleSignInUrl = Api.baseUrl + googleSignIn;
}

class GetApi extends Api {
  static const String listUserExcercises = '/listUserExcercises';
  static const String listQuestions = '/listQuestions';
  static const String listUserExcerciseUrl = Api.baseUrl + listUserExcercises;
  static const String listQuestionsUrl = Api.baseUrl + listQuestions;
}
