import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class SoundHelper {
  final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  final MicCubit micCubit;
  String? _mPath;
  String questionId;
  late Directory appDirectory;
  double silenceThreshold = 0.01;
  int _recordDuration = 0;
  Timer? _timer;
  late final AudioRecorder _audioRecorder;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;

  SoundHelper({required this.questionId, required this.micCubit}) {
    init();
  }
  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    _mPath = "${appDirectory.path}/recording$questionId.m4a";
  }

  void init() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    getDir();

    _audioRecorder = AudioRecorder();

    // recorderController = RecorderController()
    //   ..androidEncoder = AndroidEncoder.aac
    //   ..androidOutputFormat = AndroidOutputFormat.mpeg4
    //   ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    //   ..sampleRate = 44100;
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      _recordState = recordState;
      debugPrint("faaz: record state: $recordState");
    });
    DateTime? silenceStart;
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 1000))
        .listen((amp) {
      debugPrint("faaz: amplitude: ${amp.current}");
      if (amp.current < -30) {
        debugPrint("faaz: silence detected");
        silenceStart ??= DateTime.now();
        if (DateTime.now().difference(silenceStart!) >
            const Duration(seconds: 3)) {
          stopRecorder();
        }
      } else {
        silenceStart = null;
      }
    });
  }

  Future<void> record() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.aacEld;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }
        micCubit.micActive();

        final config = RecordConfig(
          encoder: AudioEncoder.wav,
          numChannels: 1,
          sampleRate: 44100,
        );

        // Record to file
        await recordFile(_audioRecorder, config);

        // Record to stream
        // await recordStream(_audioRecorder, config);

        _recordDuration = 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    await recorder.start(config, path: path);
  }

  Future<String> _getPath() async {
    final dir = await getExternalStorageDirectory();
    return p.join(
      dir!.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  }

  Future<void> cancelRecorder() async {
    await _audioRecorder.stop();
  }

  Future<void> stopRecorder() async {
    final path = await _audioRecorder.stop();

    if (path != null) {
      debugPrint('Recorded to $path');
      micCubit.micInactive(path);
    } else {
      micCubit.micError("Can't record audio. Please try again.");
    }
  }

  Future<void> _pause() => _audioRecorder.pause();

  Future<void> _resume() => _audioRecorder.resume();

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${encoder.name}');
        }
      }
    }

    return isSupported;
  }

  // Future<void> record() async {
  //   try {
  //     debugPrint("faaz: recording started : $_mPath");
  //     await _myRecorder.openRecorder();

  //     micCubit.micActive();
  //     await _myRecorder.startRecorder(
  //       toFile: "$_mPath",
  //     );
  //     _myRecorder.onProgress!.listen((event) {
  //       debugPrint("faaz: ${event.decibels}");
  //       if (event.decibels != null && event.decibels! < silenceThreshold) {
  //         _myRecorder.stopRecorder();
  //       }
  //     });
  //   } on Exception catch (e) {
  //     debugPrint("faaz: start recording error: " + e.toString());
  //   }
  // }

  // Future<void> stopRecorder() async {
  //   final path = await _myRecorder.stopRecorder();
  //   debugPrint("faaz: recording stopped: $path");
  //   micCubit.micInactive();
  // }
}
