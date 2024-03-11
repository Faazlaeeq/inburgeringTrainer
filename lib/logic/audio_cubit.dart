import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:path_provider/path_provider.dart';
// ignore: unused_import
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class AudioCubit extends Cubit<AudioState> {
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioCubit() : super(AudioInitial()) {
    // _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
    //   if (state == PlayerState.playing) {
    //     debugPrint("Audio Playing from Constructor");
    //     emit(AudioPlaying());
    //   } else if (state == PlayerState.paused) {
    //     debugPrint("Audio Paused from Constructor");

    //     emit(AudioPaused());
    //   } else if (state == PlayerState.stopped) {
    //     debugPrint("Audio Stopped from Constructor");

    //     emit(AudioStopped());
    //   }
    // });
  }

  Stream<Duration> get audioPosition => audioPlayer.onPositionChanged;
  Stream<Duration?> get audioDuration => audioPlayer.onDurationChanged;
  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    return super.close();
  }

  AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration;
  Future<File> base64ToAudio(String base64String, String fileName) async {
    debugPrint("encoding audio");
    final byteData = base64Decode(base64String);

    final path = join((await getTemporaryDirectory()).path, fileName);
    final file = File(path);

    await file.writeAsBytes(byteData);
    return file;
  }

  Future<void> playAudio(String base64String, String exerciseId) async {
    emit(AudioLoading());
    try {
      final file = await base64ToAudio(base64String, exerciseId);

      debugPrint("Playing audio");

      await audioPlayer.play(DeviceFileSource(file.path));
      duration = await audioPlayer.getDuration();
      emit(AudioPlaying(duration: duration));
      audioPlayer.onPlayerComplete.listen((event) {
        emit(AudioStopped());
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
      emit(AudioError(e.toString()));
    }
  }

  void pauseAudio() async {
    await audioPlayer.pause();
    debugPrint("Audio Paused");

    emit(AudioPaused(duration: duration));
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    debugPrint("Audio Stopped");
    emit(AudioStopped());
  }

  void resumeAudio() async {
    await audioPlayer.resume();
    debugPrint("Audio Resumed");
    emit(AudioPlaying(duration: duration));
  }
}

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioPlaying extends AudioState {
  final Duration? duration;

  AudioPlaying({this.duration = const Duration(seconds: 100)});
}

class AudioLoading extends AudioState {}

class AudioStopped extends AudioState {}

class AudioPaused extends AudioState {
  final Duration? duration;

  AudioPaused({this.duration = const Duration(seconds: 100)});
}

class AudioError extends AudioState {
  final String message;

  AudioError(this.message);
}
