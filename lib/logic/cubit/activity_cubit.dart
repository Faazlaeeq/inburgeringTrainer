import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/activity_model.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final RecordHelper recordHelper = RecordHelper();
  ActivityCubit() : super(ActivityInitial());

  Future<void> fetchActivity() async {
    try {
      debugPrint("faaz1: fetch activity called!");
      emit(ActivityLoading());
      debugPrint("faaz1: fetch activity loading called!");

      await recordHelper.initialize();
      ActivityModel activity = ActivityModel(
          totalQuestions: await recordHelper.getTotalQuestion(),
          totalAnswered: recordHelper.getTotalAnswerCount());
      debugPrint("faaz1: fetch activity loaded called!");

      emit(ActivityLoaded(activity));
    } catch (e) {
      emit(ActivityError(e.toString()));
      debugPrint(e.toString());
    }
  }
}

abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final ActivityModel activities;
  ActivityLoaded(this.activities);
}

class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}
