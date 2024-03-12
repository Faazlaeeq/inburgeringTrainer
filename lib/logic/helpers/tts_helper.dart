import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts flutterTts = FlutterTts();
  void init() {
    flutterTts.getVoices.then((value) {
      List<Map> voices = List.from(value);
      voices = voices
          .where((element) => element['locale'].contains('nl-NL'))
          .toList();
      setVoice(voices[0]);
    });

    flutterTts.setLanguage('nl-NL');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
  }

  void setVoice(Map voice) {
    flutterTts.setVoice({'name': voice['name'], 'locale': voice['locale']});
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }
}
