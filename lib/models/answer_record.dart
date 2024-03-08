import 'package:hive/hive.dart';
part 'answer_record.g.dart';

@HiveType(typeId: 3)
class AnswerRecord {
  @HiveField(0)
  final String questionId;
  @HiveField(1)
  final String exerciseId;
  @HiveField(2)
  final bool answerGiven;
  @HiveField(3)
  final String userId;

  AnswerRecord(
      {required this.questionId,
      required this.exerciseId,
      required this.answerGiven,
      required this.userId});
}
