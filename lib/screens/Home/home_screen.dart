import 'dart:core';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/cubit/activity_cubit.dart';
import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/models/exercise_model.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/screens/setting/setting_screen.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/mywidgets.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExerciseCubit exerciseCubit = ExerciseCubit(ExerciseRepository());
  late ActivityCubit activityCubit;
  int totalQuestions = 0;
  int totalAnswered = 0;
  @override
  void initState() {
    super.initState();
    exerciseCubit.fetchExercises();
    activityCubit = context.read<ActivityCubit>();
    activityCubit.fetchActivity();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Inburgering Trainer',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.refresh,
              color: MyColors.greyColor,
              size: 20,
            ),
            onPressed: () => setState(() {
              RecordHelper().clearRecord();
            }),
          ),
          trailing: IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => const SettingScreen()));
              },
              icon: const Icon(Icons.settings, color: MyColors.greyColor)),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: paddingAll2,
                  margin: paddingAll2,
                  decoration: BoxDecoration(
                    color: MyColors.cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<ActivityCubit, ActivityState>(
                      builder: (context, state) {
                    if (state is ActivityLoaded) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Activity Tracker",
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(color: MyColors.lightBlackColor),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.flag_outlined,
                                size: 20,
                                color: MyColors.primaryColor,
                              ),
                              Text(
                                  "${state.activities.totalAnswered}/ ${state.activities.totalQuestions}"),
                            ],
                          ),
                          Padding(
                            padding: paddingSymmetricVertical2,
                            child: LinearProgressIndicator(
                              value: state.activities.totalAnswered /
                                  state.activities.totalQuestions,
                              minHeight: 10,
                              backgroundColor: MyColors.bgColor,
                              valueColor: const AlwaysStoppedAnimation(
                                  MyColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    } else if (state is ActivityLoading) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Activity Tracker",
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(color: MyColors.lightBlackColor),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.flag_outlined,
                                size: 20,
                                color: MyColors.primaryColor,
                              ),
                              const CupertinoActivityIndicator
                                  .partiallyRevealed(
                                radius: 10,
                              ),
                            ],
                          ),
                          Padding(
                            padding: paddingSymmetricVertical2,
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              backgroundColor: MyColors.bgColor,
                              valueColor: const AlwaysStoppedAnimation(
                                  MyColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    } else if (state is ActivityError) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Can't load Activity Tracker",
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(color: MyColors.lightBlackColor),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.flag_outlined,
                                size: 20,
                                color: MyColors.primaryColor,
                              ),
                              const Icon(
                                Icons.error_outline,
                                color: MyColors.primaryColor,
                              ),
                            ],
                          ),
                          Padding(
                            padding: paddingSymmetricVertical2,
                            child: LinearProgressIndicator(
                              value: 1,
                              minHeight: 10,
                              backgroundColor: MyColors.bgColor,
                              valueColor: const AlwaysStoppedAnimation(
                                  MyColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
              ),
              BlocBuilder<ExerciseCubit, ExerciseState>(
                bloc: exerciseCubit,
                builder: ((context, state) {
                  if (state is ExerciseLoaded) {
                    return CardsGridwithHeading(
                      exercises: state.exercises,
                    );
                  } else {
                    return const SliverToBoxAdapter(
                        child: CupertinoActivityIndicator());
                  }
                }),
              ),
            ],
          ),
        ));
  }
}

class CardsGridwithHeading extends StatefulWidget {
  const CardsGridwithHeading({super.key, required this.exercises});
  final List<ExerciseModel> exercises;

  @override
  State<CardsGridwithHeading> createState() => _CardsGridwithHeadingState();
}

class _CardsGridwithHeadingState extends State<CardsGridwithHeading>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<ExerciseModel>> exercisesByCategory = groupBy(
      widget.exercises,
      (ExerciseModel exercise) => exercise.categoryName,
    ).values.toList();

    // int exerciseIndex = -1;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
          childCount: exercisesByCategory.length, (ctx, index) {
        // exerciseIndex++;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: padding5),
              child: Text(
                exercisesByCategory[index][0].categoryName,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index2) {
                RecordHelper recordHelper = RecordHelper();
                int? questionDone = recordHelper.getTotalAnswerCountByExercise(
                    exercisesByCategory[index][index2].id);

                return MyCard(
                    exerciseId: exercisesByCategory[index][index2].id,
                    categoryName:
                        exercisesByCategory[index][index2].exerciseName,
                    exerciseName:
                        exercisesByCategory[index][index2].exerciseName,
                    isSelected: (questionDone != null && questionDone > 0),
                    questionCompleted:
                        "${exercisesByCategory[index][index2].questionsCount.toString()}");
              },
              itemCount: exercisesByCategory[index].length,
            ),
          ],
        );
      }),
    );
  }
}
