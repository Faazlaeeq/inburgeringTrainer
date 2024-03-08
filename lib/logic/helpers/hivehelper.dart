import 'package:hive_flutter/adapters.dart';
import 'package:inburgering_trainer/models/answer_record.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';
import 'package:inburgering_trainer/models/question_model.dart';

class HiveHelper {
  static const String boxName = 'myBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseModelAdapter());
    Hive.registerAdapter(QuestionModelAdapter());
    Hive.registerAdapter(QuestionDataAdapter());
    Hive.registerAdapter(AnswerRecordAdapter());

    await Hive.openBox(boxName);
  }

  static Future<void> clearBox() async {
    await Hive.box(boxName).clear();
  }

  static Future<void> saveData(String key, dynamic value) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  static dynamic getData(String key) async {
    var box = await Hive.openBox(boxName);
    return box.get(key);
  }

  static Future<void> deleteData(String key) async {
    var box = await Hive.openBox(boxName);
    await box.delete(key);
  }
}
