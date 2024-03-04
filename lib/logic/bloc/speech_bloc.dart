import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  String speech = "";

  SpeechBloc() : super(SpeechInitial()) {
    on<SpeechEvent>((event, emit) async {
      if (event is ConcatenateSpeech) {
        speech += " ${event.speech}";
        emit(SpeechUpdated(speech));

        print("Sending request");
        emit(SpeechLoading());
        await Future.delayed(const Duration(seconds: 10));
        print("Loading emitted");
        // await apiCall.sendRequest(event.speech).then((value) {
        //   emit(SpeechResponse(value));
        // });

        print("Response emitted");
      }
      if (event is EmptySpeech) {
        speech = "";
        emit(SpeechEmpty());
      }
    });
  }
}
