import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/question_model.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/myexceptions.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository _questionRepository;

  QuestionCubit(this._questionRepository) : super(QuestionInitial());

  Future<void> getQuestions({String? exerciseId, String? userId}) async {
    emit(QuestionLoading());
    try {
      List<QuestionModel>? questions;

      questions = await _questionRepository.getQuestions(
          exerciseId: exerciseId, userId: userId);
      emit(QuestionLoaded(questions, exerciseId: exerciseId!));
      return;
    } on NoInternetException catch (e) {
      emit(QuestionError(e.toString()));
      debugPrint("Error from Cubit:$e");
    } catch (e) {
      emit(QuestionError(
          'Error loading Exercise questions, Please try again later. if this continues contact support and add below given information.\n\nTechnical Information : $e'));
      debugPrint("Error from Cubit:$e");
    }
    // try {
    // final questions = await _questionRepository.getQuestions(
    //     exerciseId: exerciseId, userId: userId);

    //   List<QuestionModel>? cachedQuestions;
    //   final netStatus = await InternetHelper.checkInternetConnectivity();
    //   try {
    //     final List<dynamic>? cachedQuestionsList =
    //         await HiveHelper.getData('questions') as List<dynamic>?;
    //     if (cachedQuestionsList != null) {
    //       cachedQuestions =
    //           cachedQuestionsList.map((item) => item as QuestionModel).toList();
    //       debugPrint('questions from hive:${cachedQuestions.length}');
    //       emit(QuestionLoaded(cachedQuestions));
    //     }

    //     if (netStatus) {
    //       if (cachedQuestions == null) {
    //         cachedQuestions = questions;
    //         await HiveHelper.saveData('questions', cachedQuestions);
    //         emit(QuestionLoaded(cachedQuestions));
    //         return;
    //       } else if (cachedQuestions != questions) {
    //         cachedQuestions = questions;
    //         await HiveHelper.saveData('questions', cachedQuestions);
    //       }
    //       cachedQuestions =
    //           await HiveHelper.getData('questions') as List<QuestionModel>?;
    //     }
    //   } on TypeError catch (e) {
    //     debugPrint("Error from Hive:${e.toString()}");
    //     if (netStatus) {
    //       return;
    //     }
    //     cachedQuestions = questions;
    //     await HiveHelper.saveData('questions', cachedQuestions);
    //   }

    //   emit(QuestionLoaded(cachedQuestions!));
    // } catch (e) {
    //   emit(QuestionError('Failed to fetch questions : $e'));
    //   debugPrint("Error from Cubit:$e");
    // }
  }
}

abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<QuestionModel> questions;
  final String exerciseId;
  QuestionLoaded(this.questions, {required this.exerciseId}) {
    RecordHelper recordHelper = RecordHelper();
    questions.sort((a, b) {
      bool aAnswered = recordHelper.getAnswerGiven(a.id);
      bool bAnswered = recordHelper.getAnswerGiven(b.id);

      if (aAnswered && !bAnswered) {
        return 1;
      } else if (!aAnswered && bAnswered) {
        return -1;
      } else {
        return 0;
      }
    });
  }
}

class QuestionError extends QuestionState {
  final String message;

  QuestionError(this.message);
}
