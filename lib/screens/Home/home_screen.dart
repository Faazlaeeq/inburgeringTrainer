import 'dart:core';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/models/exersiceModel.dart';
import 'package:inburgering_trainer/repository/exercise_repository.dart';
import 'package:inburgering_trainer/screens/Home/question_screen.dart';
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

  @override
  void initState() {
    super.initState();
    exerciseCubit.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Inburgering Trainer',
          ),
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
                  child: Column(
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
                          Spacer(),
                          Icon(
                            Icons.flag_outlined,
                            size: 20,
                            color: MyColors.primaryColor,
                          ),
                          Text("F3/ 208")
                        ],
                      ),
                      Padding(
                        padding: paddingSymmetricVertical2,
                        child: LinearProgressIndicator(
                          value: 0.5,
                          minHeight: 10,
                          backgroundColor: MyColors.bgColor,
                          valueColor: const AlwaysStoppedAnimation(
                              MyColors.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
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

class CardsGridwithHeading extends StatelessWidget {
  const CardsGridwithHeading({super.key, required this.exercises});
  final List<ExerciseModel> exercises;

  @override
  Widget build(BuildContext context) {
    List<List<ExerciseModel>> exercisesByCategory = groupBy(
      exercises,
      (ExerciseModel exercise) => exercise.categoryName,
    ).values.toList();
    int exerciseIndex = -1;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
          childCount: exercisesByCategory.length, (context, index) {
        exerciseIndex++;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: padding5),
              child: Text(
                exercisesByCategory[index][exerciseIndex].categoryName,
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
                return MyCard(
                    categoryName:
                        exercisesByCategory[index][exerciseIndex].categoryName,
                    exerciseName:
                        exercisesByCategory[index][index2].exerciseName,
                    questionCompleted:
                        "0/${exercisesByCategory[index][index2].questionsCount.toString()}");
              },
              itemCount: exercisesByCategory[index].length,
            ),
          ],
        );
      }),
    );
  }
}
