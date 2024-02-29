class QuestionModel {
  final String id;
  final QuestionData questionData;
  final String questionType;
  final String type;

  QuestionModel({
    required this.id,
    required this.questionData,
    required this.questionType,
    required this.type,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      questionData: QuestionData.fromJson(json['questionData']),
      questionType: json['questionType'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionData': questionData.toJson(),
      'questionType': questionType,
      'type': type,
    };
  }
}

class QuestionData {
  final String answerSound;
  final List<String> images;
  final List<String> imageURLs;
  final String questionSound;
  final String questionText;
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
