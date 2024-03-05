import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechListner {
  late BuildContext context;
  final streamController = StreamController<String>.broadcast();

  late Bloc speechBloc = BlocProvider.of<SpeechBloc>(context);

  SpeechListner(this.context) {
    speechInit();
    // speechBloc.add(ConcatenateSpeech(speech: "hi"));
  }

  SpeechToText speech = SpeechToText();

  void onResultHandler(SpeechRecognitionResult val) {
    speechBloc.add(ConcatenateSpeech(speech: val.recognizedWords));
    print(val.recognizedWords);
    stopListening();
  }

  void startListening() async {
    speechBloc.add(EmptySpeech());

    BlocProvider.of<MicCubit>(context).micActive();
    SpeechListenOptions options = SpeechListenOptions(
        partialResults: false,
        autoPunctuation: true,
        enableHapticFeedback: true,
        listenMode: ListenMode.dictation,
        cancelOnError: true);
    await speech
        .listen(
      listenOptions: options,
      onResult: onResultHandler,
      listenFor: const Duration(seconds: 10),
      localeId: 'nl_NL',
      onSoundLevelChange: (level) => print('Sound level $level'),
    )
        .catchError((e) {
      print(e);
      BlocProvider.of<MicCubit>(context).micError();
    });
  }

  void stopListening() {
    speech.stop();
    BlocProvider.of<MicCubit>(context).micInactive();
  }

  void speechInit() {
    speech
        .initialize(
      finalTimeout: const Duration(seconds: 5),
      onStatus: (status) => {if (status == 'notListening') stopListening()},
    )
        .then((available) {
      if (available) {
        BlocProvider.of<MicCubit>(context).micActive();
        startListening();
      } else {
        BlocProvider.of<MicCubit>(context).micError();
      }
    });
  }

  // Closing the stream when the listen function completes or isSpeechAvailable is false
  Future<void> close() async {
    streamController.stream.listen((_) {}).cancel();
    streamController.close();
  }
}
