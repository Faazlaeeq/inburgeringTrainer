import 'package:hive_flutter/adapters.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 4)
class ActivityModel {
  @HiveField(0)
  int totalQuestions;
  @HiveField(1)
  int totalAnswered;

  ActivityModel({
    required this.totalQuestions,
    required this.totalAnswered,
  });
}
