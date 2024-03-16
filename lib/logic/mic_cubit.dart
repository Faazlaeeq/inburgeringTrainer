import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mic_state.dart';

class MicCubit extends Cubit<MicState> {
  MicCubit() : super(MicInitial());

  void micActive() {
    emit(MicActive());
  }

  void micInactive(String path) {
    emit(MicInactive(path: path));
    try {
      List<int> audioBytes = File(path).readAsBytesSync();

      String base64Audio = base64Encode(audioBytes);
    } catch (e) {}
  }

  void micError(String error) {
    emit(MicError(error: error));
  }

  void micInitial() {
    emit(MicInitial());
  }
}
