import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/answer_record.dart';
import 'package:inburgering_trainer/repository/answer_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class AnswerCubit extends HydratedCubit<AnswerState> {
  late AnswerRepository answerRepository;
  String id;
  AnswerCubit({this.id = "init"}) : super(AnswerInitial()) {
    answerRepository = AnswerRepository();
  }

  void clearAnswer() {
    emit(AnswerInitial());
  }

  Future<void> postAnswer(String question, String answer, String userID,
      String exerciseId, String questionId) async {
    emit(AnswerLoading());
    try {
      final response =
          await answerRepository.postAnswer(question, answer, userID);

      RecordHelper answerRecordHelper = RecordHelper();
      await answerRecordHelper.initialize();
      answerRecordHelper.addAnswerRecord(AnswerRecord(
          questionId: questionId,
          exerciseId: exerciseId,
          answerGiven: true,
          userId: userID));
      emit(AnswerLoaded(response["correction"] as String, userAnswer: answer));
    } catch (e) {
      emit(AnswerError(e.toString()));
    }
  }

  @override
  AnswerState? fromJson(Map<String, dynamic> json) {
    try {
      final response = json['response'] as String;
      final userAnswer = json['userAnswer'] as String?;
      return AnswerLoaded(response, userAnswer: userAnswer);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AnswerState state) {
    if (state is AnswerLoaded) {
      return {
        'response': state.response,
        'userAnswer': state.userAnswer,
      };
    }
    return null;
  }
}

class AnswerState extends Equatable {
  @override
  List<Object> get props => [];
}

class AnswerInitial extends AnswerState {}

class AnswerLoading extends AnswerState {}

class AnswerLoaded extends AnswerState {
  final String response;
  final String? userAnswer;
  AnswerLoaded(this.response, {this.userAnswer});
  @override
  List<Object> get props => [response];
}

class AnswerError extends AnswerState {
  final String error;
  AnswerError(this.error);
  @override
  List<Object> get props => [error];
}
