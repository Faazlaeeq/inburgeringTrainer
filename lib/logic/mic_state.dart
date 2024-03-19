part of 'mic_cubit.dart';

@immutable
abstract class MicState {}

class MicInitial extends MicState {}

class MicActive extends MicState {}

class MicInactive extends MicState {
  final String path;
  MicInactive({required this.path});
}

class MicText extends MicState {
  final String text;
  final String path;
  MicText({required this.text, required this.path});
}

class MicError extends MicState {
  final String error;
  MicError({required this.error});
}
