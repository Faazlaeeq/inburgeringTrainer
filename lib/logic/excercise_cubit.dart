import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/utils/myexceptions.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository exerciseRepository;

  ExerciseCubit(this.exerciseRepository) : super(ExerciseInitial());

  Future<void> fetchExercises() async {
    emit(ExerciseLoading());
    try {
      List<ExerciseModel>? exercises;
      final netStatus = await InternetHelper.checkInternetConnectivity();
      try {
        final List<dynamic>? exList =
            await HiveHelper.getData('exercises') as List<dynamic>?;
        if (exList != null) {
          exercises = exList.map((item) => item as ExerciseModel).toList();
          debugPrint('exercises from hive:${exercises.length}');
          emit(ExerciseLoaded(exercises));
        }
        if (netStatus) {
          if (exercises == null) {
            exercises = await exerciseRepository.getUserExercises();
            await HiveHelper.saveData('exercises', exercises);
            emit(ExerciseLoaded(exercises));
            return;
          } else if (exercises != await exerciseRepository.getUserExercises()) {
            exercises = await exerciseRepository.getUserExercises();
            emit(ExerciseLoaded(exercises));

            await HiveHelper.saveData('exercises', exercises);
          }
          exercises =
              await HiveHelper.getData('exercises') as List<ExerciseModel>?;
        } else {
          throw NoInternetException(
              message:
                  "No Internet connection!\n\n This app need internet connection at first load to store exercises for offline usage.");
        }
      } on TypeError catch (e) {
        debugPrint("Error from Hive:${e.toString()}");
        if (netStatus) {
          return;
        }
        exercises = await exerciseRepository.getUserExercises();
        await HiveHelper.saveData('exercises', exercises);
      } on NoInternetException catch (e) {
        emit(ExerciseError(e.toString()));
        debugPrint("Error from Cubit:$e");
      }

      // emit(ExerciseLoaded(exercises!));
    } catch (e) {
      emit(ExerciseError('Failed to fetch exercises : $e'));
      debugPrint("Error from Cubit:$e");
    }
  }
}

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<ExerciseModel> exercises;

  ExerciseLoaded(this.exercises);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}
