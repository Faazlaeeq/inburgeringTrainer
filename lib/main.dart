import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/cubits/excercise_cubit.dart';
import 'package:inburgering_trainer/cubits/question_cubit.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/theme/theme.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/screens/Home/home_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final excerciseCubit = ExerciseCubit(ExerciseRepository());
  final questionCubit = QuestionCubit(QuestionRepository());
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => excerciseCubit),
        BlocProvider(create: (context) => questionCubit),
      ],
      child: CupertinoApp(
          theme: MyTheme.lightTheme(context), home: const HomeScreen()),
    );
  }
}
