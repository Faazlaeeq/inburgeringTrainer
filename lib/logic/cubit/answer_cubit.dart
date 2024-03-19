import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/answer_record.dart';
import 'package:inburgering_trainer/repository/answer_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class AnswerCubit extends HydratedCubit<AnswerState> {
  late AnswerRepository answerRepository;
  @override
  String id;
  AnswerCubit({this.id = "init"}) : super(AnswerInitial()) {
    answerRepository = AnswerRepository();
  }

  void clearAnswer() {
    emit(AnswerInitial());
  }

  Future<void> postAnswer(String question, String answer, String userID,
      String exerciseId, String questionId, String path) async {
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
      emit(AnswerLoaded(response["correction"] as String,
          userAnswer: answer, path: path));
    } catch (e) {
      debugPrint(e.toString());
      emit(AnswerError("Something went wrong, please try again later"));
    }
  }

  @override
  AnswerState? fromJson(Map<String, dynamic> json) {
    try {
      final response = json['response'] as String;
      final userAnswer = json['userAnswer'] as String?;
      final path = json['path'] as String;
      return AnswerLoaded(response, userAnswer: userAnswer, path: path);
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
        'path': state.path
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
  final String path;
  AnswerLoaded(this.response, {this.userAnswer, required this.path});
  @override
  List<Object> get props => [response];
}

class AnswerError extends AnswerState {
  final String error;
  AnswerError(this.error);
  @override
  List<Object> get props => [error];
}
