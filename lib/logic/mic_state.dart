part of 'mic_cubit.dart';

@immutable
abstract class MicState {}

class MicInitial extends MicState {}

class MicActive extends MicState {}

class MicInactive extends MicState {}

class MicError extends MicState {}
