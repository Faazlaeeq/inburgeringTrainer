import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/activity_model.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final RecordHelper recordHelper = RecordHelper();
  ActivityCubit() : super(ActivityInitial());

  double lastActivityProgress = 0;
  String lastActivity = "";

  Future<void> fetchActivity() async {
    try {
      emit(ActivityLoading(
          lastActivityProgress: lastActivityProgress,
          lastActivity: lastActivity));

      await recordHelper.initialize();
      ActivityModel activity = ActivityModel(
          totalQuestions: await recordHelper.getTotalQuestion(),
          totalAnswered: recordHelper.getTotalAnswerCount());

      emit(ActivityLoaded(activity));
      lastActivityProgress = activity.totalAnswered / activity.totalQuestions;
      lastActivity = "${activity.totalAnswered}/${activity.totalQuestions}";
    } catch (e) {
      emit(ActivityError(e.toString()));
      debugPrint(e.toString());
    }
  }
}

abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {
  final double lastActivityProgress;
  final String lastActivity;
  ActivityLoading({this.lastActivityProgress = 0, this.lastActivity = ""});
}

class ActivityLoaded extends ActivityState {
  final ActivityModel activities;
  ActivityLoaded(this.activities);
}

class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}
