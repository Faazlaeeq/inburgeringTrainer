// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswerRecordAdapter extends TypeAdapter<AnswerRecord> {
  @override
  final int typeId = 3;

  @override
  AnswerRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerRecord(
      questionId: fields[0] as String,
      exerciseId: fields[1] as String,
      answerGiven: fields[2] as bool,
      userId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.exerciseId)
      ..writeByte(2)
      ..write(obj.answerGiven)
      ..writeByte(3)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
