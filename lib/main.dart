import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inburgering_trainer/cubits/excercise_cubit.dart';
import 'package:inburgering_trainer/lib/theme.dart';
import 'package:inburgering_trainer/repository/excercise_repo.dart';
import 'package:inburgering_trainer/screens/Home/home_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final excerciseCubit = ExerciseCubit(ExerciseRepository());
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: MyTheme.lightTheme(context),
      home: BlocProvider(
          create: (context) => excerciseCubit, child: const HomeScreen()),
    );
  }
}
