import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mic_state.dart';

class MicCubit extends Cubit<MicState> {
  MicCubit() : super(MicInitial());

  void micActive() {
    emit(MicActive());
  }

  void micInactive() {
    emit(MicInactive());
  }

  void micError() {
    emit(MicError());
  }

  void micInitial() {
    emit(MicInitial());
  }
}
