// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 1)
class QuestionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final QuestionData questionData;
  @HiveField(2)
  final String questionType;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final String? lastFetched;

  QuestionModel({
    required this.id,
    required this.questionData,
    required this.questionType,
    required this.type,
    this.lastFetched,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      questionData: QuestionData.fromJson(json['questionData']),
      questionType: json['questionType'],
      type: json['type'],
      lastFetched: json['lastFetched'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionData': questionData.toJson(),
      'questionType': questionType,
      'type': type,
      'lastFetched': lastFetched,
    };
  }
}

@HiveType(typeId: 2)
class QuestionData {
  @HiveField(0)
  final String answerSound;
  @HiveField(1)
  final List<String> images;
  @HiveField(2)
  final List<String> imageURLs;
  @HiveField(3)
  final String questionSound;
  @HiveField(4)
  final String questionText;
  @HiveField(5)
  final String suggestedAnswer;

  QuestionData({
    required this.answerSound,
    required this.images,
    required this.imageURLs,
    required this.questionSound,
    required this.questionText,
    required this.suggestedAnswer,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      answerSound: json['answerSound'],
      images: List<String>.from(json['images']),
      imageURLs: List<String>.from(json['imageURLs']),
      questionSound: json['questionSound'],
      questionText: json['questionText'],
      suggestedAnswer: json['suggestedAnswer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerSound': answerSound,
      'images': images,
      'imageURLs': imageURLs,
      'questionSound': questionSound,
      'questionText': questionText,
      'suggestedAnswer': suggestedAnswer,
    };
  }
}
