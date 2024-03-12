import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts _flutterTts = FlutterTts();
  late Map _currentVoice;
  void init() {
    print("in here");
    _flutterTts.getVoices.then((value) {
      List<Map> voices = List.from(value);
      voices = voices
          .where((element) => element['locale'].contains('nl-NL'))
          .toList();
      print(voices);
      setVoice(voices[0]);
    });

    _flutterTts.setLanguage('nl-NL');
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({'name': voice['name'], 'locale': voice['locale']});
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
}
