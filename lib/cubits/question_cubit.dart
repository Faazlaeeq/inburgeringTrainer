import 'package:inburgering_trainer/models/question_model.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository _questionRepository;

  QuestionCubit(this._questionRepository) : super(QuestionInitial());

  Future<void> getQuestions() async {
    try {
      emit(QuestionLoading());
      final questions = await _questionRepository.getQuestions();
      emit(QuestionLoaded(questions));
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }
}

abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<QuestionModel> questions;

  QuestionLoaded(this.questions);
}

class QuestionError extends QuestionState {
  final String message;

  QuestionError(this.message);
}
