import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
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
    if (kDebugMode) {
      print("faaz: ${val.recognizedWords}");
    }
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
        BlocProvider.of<MicCubit>(context).micError();
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
      BlocProvider.of<MicCubit>(context).micInactive();
    }
  }

  void stopListening() async {
    debugPrint("faaz:stopListening Called");
    await speech.stop();
  }

  void speechInit() {
    speech
        .initialize(
      finalTimeout: const Duration(seconds: 20),
      onStatus: (status) {
        debugPrint("faaz:$status");
        if (status == 'notListening' || status == 'done') {
          debugPrint("faaz: in here");
          stopListening();
          BlocProvider.of<MicCubit>(context).micInitial();
        }
      },
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
