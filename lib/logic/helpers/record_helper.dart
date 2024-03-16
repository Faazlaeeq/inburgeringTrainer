import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/helpers/hivehelper.dart';
import 'package:inburgering_trainer/logic/helpers/internet_helper.dart';
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

  FutureOr<int> getTotalQuestion() async {
    int? totCacheQues = await HiveHelper.getData("totalQuestion");
    bool netStatus = await InternetHelper.checkInternetConnectivity();
    if (totCacheQues != null) {
      if (netStatus) {
        final ExerciseRepository exerciseRepository = ExerciseRepository();
        totalQuestion = await exerciseRepository.getTotalQuestions();
        if (totalQuestion != totCacheQues) {
          HiveHelper.saveData("totalQuestion", totalQuestion);
          return totalQuestion;
        }
        return totalQuestion;
      }
      return totCacheQues;
    } else {
      final ExerciseRepository exerciseRepository = ExerciseRepository();
      totalQuestion = await exerciseRepository.getTotalQuestions();
      HiveHelper.saveData("totalQuestion", totalQuestion);
    }
    return totalQuestion;
  }

  void addAnswerRecord(AnswerRecord answerRecord) {
    // debugPrint("AnswerRecord added to Hive: ${answerRecord.questionId}");
    for (var element in answerRecords) {
      debugPrint("AnswerRecord: ${element.questionId}");
    }
    if (!answerRecords
        .any((element) => element.questionId == answerRecord.questionId)) {
      answerRecords.add(answerRecord);
      debugPrint(
          "AnswerRecord added to Hive: $answerRecord and $answerRecords");
      HiveHelper.saveData("answerRecord", answerRecords);
    }
    // HiveHelper.deleteData("answerRecord");
  }

  void clearRecord() {
    HiveHelper.deleteData("answerRecord");
  }

  List<AnswerRecord> getAnswerbyExercise(String exerciseId) {
    return answerRecords
        .where((element) => element.exerciseId == exerciseId)
        .toList();
  }

  bool getAnswerGiven(String questionId) {
    // debugPrint("faaz: record is empty ${answerRecords == []} $answerRecords");
    if (answerRecords.isNotEmpty) {
      return answerRecords
          .firstWhere(
            (element) => element.questionId == questionId,
            orElse: () => AnswerRecord(
                userId: "user",
                exerciseId: "kuch bhi",
                questionId: questionId,
                answerGiven: false),
          )
          .answerGiven;
    } else {
      return false;
    }
  }

  int getTotalAnswerCount() {
    debugPrint(answerRecords.toString());
    return answerRecords.where((element) => element.answerGiven == true).length;
  }

  int? getTotalAnswerCountByExercise(String exerciseId) {
    // debugPrint("faaz: exerciseId: $exerciseId");
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
