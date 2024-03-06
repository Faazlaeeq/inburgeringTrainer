import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/excercise_cubit.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/theme/theme.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/screens/Home/home_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

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
        BlocProvider(create: (context) => AudioCubit()),
        BlocProvider(create: (context) => MicCubit()),
        BlocProvider(create: (context) => SpeechBloc()),
        // BlocProvider(
        //   create: (context) => AnswerCubit(),
        // )
      ],
      child: MaterialApp(
        home: CupertinoApp(
            theme: MyTheme.lightTheme(context), home: const HomeScreen()),
      ),
    );
  }
}
