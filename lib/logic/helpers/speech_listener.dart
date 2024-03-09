import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechListner {
  final streamController = StreamController<String>.broadcast();

  SpeechBloc speechBloc;
  MicCubit micCubit;
  SpeechListner({required this.speechBloc, required this.micCubit}) {
    speechInit();
  }

  SpeechToText speech = SpeechToText();

  Future<void> onResultHandler(SpeechRecognitionResult val) async {
    speechBloc.add(ConcatenateSpeech(speech: val.recognizedWords));
    if (kDebugMode) {
      print("faaz: ${val.recognizedWords}");
    }
    await stopListening();
  }

  void startListening() async {
    speechBloc.add(EmptySpeech());
    micCubit.micActive();

    SpeechListenOptions options = SpeechListenOptions(
        partialResults: false,
        autoPunctuation: true,
        enableHapticFeedback: true,
        listenMode: ListenMode.dictation,
        cancelOnError: true);
    final bool netStatus = await InternetHelper.checkInternetConnectivity();
    if (netStatus) {
      await speech
          .listen(
        listenOptions: options,
        onResult: onResultHandler,
        listenFor: const Duration(seconds: 10),
        localeId: 'nl_NL',
      )
          .catchError((e) {
        debugPrint(e);
        micCubit.micError();
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Seems like you device is not connected to the internet.Please connect to the internet and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColors.blackLightColor,
          textColor: MyColors.whiteColor,
          fontSize: 16.0);
      micCubit.micInactive();
    }
  }

  Future<void> stopListening() async {
    debugPrint("faaz:stopListening Called");
    await speech.stop();
  }

  void speechInit() async {
    bool available = await speech.initialize(
      finalTimeout: const Duration(seconds: 20),
      onStatus: (status) {
        debugPrint("faaz:$status");
        if (status == 'notListening' || status == 'done') {
          debugPrint("faaz: in here");
          stopListening();
          micCubit.micInitial();
        }
      },
    );
    if (!available) {
      micCubit.micError();
    }
  }

  // Closing the stream when the listen function completes or isSpeechAvailable is false
  Future<void> close() async {
    streamController.stream.listen((_) {}).cancel();
    streamController.close();
  }
}
