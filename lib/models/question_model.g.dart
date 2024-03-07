// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 1;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      id: fields[0] as String,
      questionData: fields[1] as QuestionData,
      questionType: fields[2] as String,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionData)
      ..writeByte(2)
      ..write(obj.questionType)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionDataAdapter extends TypeAdapter<QuestionData> {
  @override
  final int typeId = 2;

  @override
  QuestionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionData(
      answerSound: fields[0] as String,
      images: (fields[1] as List).cast<String>(),
      imageURLs: (fields[2] as List).cast<String>(),
      questionSound: fields[3] as String,
      questionText: fields[4] as String,
      suggestedAnswer: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.answerSound)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.imageURLs)
      ..writeByte(3)
      ..write(obj.questionSound)
      ..writeByte(4)
      ..write(obj.questionText)
      ..writeByte(5)
      ..write(obj.suggestedAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
