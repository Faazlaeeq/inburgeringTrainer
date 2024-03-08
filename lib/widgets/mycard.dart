import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/screens/Home/question_screen.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:flutter/cupertino.dart';

class MyCard extends StatefulWidget {
  const MyCard(
      {super.key,
      required this.exerciseName,
      required this.questionCompleted,
      required this.categoryName,
      required this.exerciseId,
      this.isSelected = false});

  final String exerciseName;
  final String questionCompleted;
  final String categoryName;
  final String exerciseId;
  final bool isSelected;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = widget.isSelected;
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => QuestionScreen(
              title: widget.categoryName,
              exerciseId: widget.exerciseId,
            ),
          ),
        );
      },
      child: Container(
        margin: paddingAll2,
        padding: paddingAll2,
        decoration: BoxDecoration(
          color: isSelected ? MyColors.accentBlueColor : MyColors.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? MyColors.outlineBlueColor : MyColors.outlineColor,
            width: 1,
          ),
        ),
        width: width(context) / 2,
        child: Stack(
          children: [
            Center(
              child: Text(
                widget.exerciseName,
              ),
            ),
            BlocBuilder<AnswerCubit, AnswerState>(
              builder: (context, state) {
                RecordHelper recordHelper = RecordHelper();
                int? questionDone = recordHelper
                    .getTotalAnswerCountByExercise(widget.exerciseId);
                return Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      "${questionDone ?? 0}/ ${widget.questionCompleted}",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: MyColors.primaryColor),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
