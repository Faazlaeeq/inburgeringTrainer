import 'package:record/record.dart';

class SoundHelper {
  final record = AudioRecorder();
  final String path;

  SoundHelper(this.path);
  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      await record.start(const RecordConfig(), path: path);
      print("recording");
    }
  }

  Future<String?> stopRecording() async {
    final path = await record.stop();
    return path;
  }

  // Future<void> cancelRecording() async {
  //   await record.();
  // }

  void dispose() {
    record.dispose();
  }
}
