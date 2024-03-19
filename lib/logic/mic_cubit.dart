import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:inburgering_trainer/config/api.dart';
import 'package:inburgering_trainer/logic/helpers/auth_helper.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:meta/meta.dart';

part 'mic_state.dart';

class MicCubit extends Cubit<MicState> {
  MicCubit() : super(MicInitial());

  void micActive() {
    emit(MicActive());
  }

  void micInactive(String path) async {
    emit(MicInactive(path: path));
    try {
      List<int> audioBytes = File(path).readAsBytesSync();

      String base64Audio = base64Encode(audioBytes);
      final data = {
        'audio': base64Audio,
        'service': 'google',
        'code': 'nl',
        'userID': AuthHelper.userId
      };
      debugPrint('faaz: data from micInactive : $data');
      debugPrint('faaz: path from micInactive : ${AuthHelper.userId}');
      var response = await Dio().post(
        PostApi.sendTranscriptUrl,
        data: data,
        options: Options(headers: {'x-api-key': Api.apiKey}),
      );

      debugPrint('faaz: response from sendTranscriptUrl : $response');
      emit(MicText(text: response.data['transcript'], path: path));
    } catch (e) {
      debugPrint('faaz: error from micInactive : $e');
    }
  }

  void micError(String error) {
    emit(MicError(error: error));
  }

  void micInitial() {
    emit(MicInitial());
  }
}
