import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechListner {
  final streamController = StreamController<String>.broadcast();

  SpeechBloc speechBloc;
  MicCubit micCubit;

  //Recording
  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  String questionId;
  SpeechListner(
      {required this.speechBloc,
      required this.micCubit,
      required this.questionId}) {
    speechInit();
    _initialiseControllers();
    _getDir();
  }
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording$questionId.m4a";
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
      speech
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
      // startRecording();
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
    await stopRecording();
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

  Future<void> startRecording() async {
    try {
      await recorderController.record(path: path);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      recorderController.reset();

      path = await recorderController.stop(false);

      if (path != null) {
        isRecordingCompleted = true;
        debugPrint(path);
        debugPrint("Recorded file size: ${File(path!).lengthSync()}");
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  // Closing the stream when the listen function completes or isSpeechAvailable is false
  Future<void> close() async {
    streamController.stream.listen((_) {}).cancel();

    streamController.close();
    recorderController.dispose();
  }
}
