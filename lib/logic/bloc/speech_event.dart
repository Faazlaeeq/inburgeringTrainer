part of 'speech_bloc.dart';

@immutable
abstract class SpeechEvent extends Equatable {
  const SpeechEvent();

  @override
  List<Object> get props => [];
}

class ConcatenateSpeech extends SpeechEvent {
  final String speech;

  const ConcatenateSpeech({required this.speech});

  @override
  List<Object> get props => [speech];
}

class EmptySpeech extends SpeechEvent {}
