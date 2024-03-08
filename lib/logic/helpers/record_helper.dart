import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/models/answer_record.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class RecordHelper {
  static List<AnswerRecord> answerRecords = [];
  static int totalQuestion = 0;
  RecordHelper();

  Future<void> initialize() async {
    List? cachedList = await HiveHelper.getData("answerRecord");
    if (cachedList != null) {
      answerRecords = cachedList.map((e) => e as AnswerRecord).toList();
    }
  }

  Future<int> getTotalQuestion() async {
    final ExerciseRepository exerciseRepository = ExerciseRepository();
    totalQuestion = await exerciseRepository.getTotalQuestions();
    return totalQuestion;
  }

  void addAnswerRecord(AnswerRecord answerRecord) {
    answerRecords.add(answerRecord);
    HiveHelper.saveData("answerRecord", answerRecords);
    debugPrint("AnswerRecord added to Hive: $answerRecord and $answerRecords");
  }

  List<AnswerRecord> getAnswerbyExercise(String exerciseId) {
    return answerRecords
        .where((element) => element.exerciseId == exerciseId)
        .toList();
  }

  bool getAnswerGiven(String questionId) {
    return answerRecords
        .firstWhere((element) => element.questionId == questionId)
        .answerGiven;
  }

  int getTotalAnswerCount() {
    debugPrint(answerRecords.toString());
    return answerRecords.where((element) => element.answerGiven == true).length;
  }

  int getTotalAnswerCountByExercise(String exerciseId) {
    return answerRecords
        .where((element) =>
            element.exerciseId == exerciseId && element.answerGiven == true)
        .length;
  }

  void removeAnswerRecord(AnswerRecord answerRecord) {
    answerRecords.remove(answerRecord);
  }

  void clearAnswerRecords() {
    answerRecords.clear();
  }

  void updateAnswerRecord(AnswerRecord answerRecord) {
    final index = answerRecords
        .indexWhere((element) => element.exerciseId == answerRecord.exerciseId);
    answerRecords[index] = answerRecord;
  }
}
