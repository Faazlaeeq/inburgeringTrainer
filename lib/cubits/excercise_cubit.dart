import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/repository/excercise_repo.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository exerciseRepository;

  ExerciseCubit(this.exerciseRepository) : super(ExerciseInitial());

  Future<void> fetchExercises() async {
    emit(ExerciseLoading());
    try {
      final exercises = await exerciseRepository.getQuestions();
      emit(ExerciseLoaded(exercises));
    } catch (e) {
      emit(ExerciseError('Failed to fetch exercises : $e'));
      print(e);
    }
  }
}

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final Map exercises;
  // final List<Exercise> exercises;

  ExerciseLoaded(this.exercises);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}
