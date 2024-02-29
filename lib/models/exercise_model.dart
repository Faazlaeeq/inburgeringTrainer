import 'dart:convert';

class ExerciseModel {
  String id;
  int questionsCount;
  bool isPaid;
  String exerciseName;
  String type;
  String categoryName;
  ExerciseModel(
      {required this.id,
      required this.questionsCount,
      required this.isPaid,
      required this.exerciseName,
      required this.type,
      required this.categoryName});

  factory ExerciseModel.fromJson(String jsonString, String categoryName) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return ExerciseModel(
        id: data['id'],
        questionsCount: data['questionsCount'] as int,
        isPaid: data['isPaid'] == "true",
        exerciseName: data['exerciseName'],
        type: data['type'],
        categoryName: categoryName);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionsCount': questionsCount,
      'isPaid': isPaid,
      'exerciseName': exerciseName,
      'type': type,
      'categoryName': categoryName
    };
  }
}
