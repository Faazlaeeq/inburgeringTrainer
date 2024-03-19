import 'package:inburgering_trainer/utils/imports.dart';

class PlayerCubit extends Cubit<bool> {
  PlayerCubit() : super(false);

  void play() => emit(true);
  void stop() => emit(false);
}
