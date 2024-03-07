import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
import 'package:inburgering_trainer/models/question_model.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository _questionRepository;

  QuestionCubit(this._questionRepository) : super(QuestionInitial());

  Future<void> getQuestions({String? exerciseId, String? userId}) async {
    emit(QuestionLoading());
    try {
      List<QuestionModel>? questions;
      final netStatus = await InternetHelper.checkInternetConnectivity();
      if (!netStatus) {
        final List<dynamic>? quesList =
            await HiveHelper.getData(exerciseId.toString()) as List<dynamic>?;
        debugPrint('questions from hive:${quesList}');
        if (quesList != null) {
          questions = quesList.map((item) => item as QuestionModel).toList();
          debugPrint('questions from hive:${questions.length}');
          emit(QuestionLoaded(questions));
        } else {
          emit(QuestionError(
              "No Internet connection!\n\n This app need internet connection at first load to store exercises for offline usage."));
        }
      }
      if (netStatus) {
        if (questions == null) {
          questions = await _questionRepository.getQuestions(
              exerciseId: exerciseId, userId: userId);
          await HiveHelper.saveData(exerciseId.toString(), questions);
          emit(QuestionLoaded(questions));
          return;
        }
      }
      if (questions != null) {
        emit(QuestionLoaded(questions));
      }
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

  QuestionLoaded(this.questions);
}

class QuestionError extends QuestionState {
  final String message;

  QuestionError(this.message);
}
