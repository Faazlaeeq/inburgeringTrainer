import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository exerciseRepository;

  ExerciseCubit(this.exerciseRepository) : super(ExerciseInitial());

  Future<void> fetchExercises() async {
    emit(ExerciseLoading());
    try {
      final exercises = await exerciseRepository.getUserExercises();
      emit(ExerciseLoaded(exercises));
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
