import 'package:inburgering_trainer/screens/Home/question_screen.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:flutter/cupertino.dart';

class MyCard extends StatefulWidget {
  const MyCard(
      {super.key,
      required this.exerciseName,
      required this.questionCompleted,
      required this.categoryName});

  final String exerciseName;
  final String questionCompleted;
  final String categoryName;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => QuestionScreen(
              title: widget.categoryName,
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
            Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  widget.questionCompleted,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: MyColors.primaryColor),
                )),
          ],
        ),
      ),
    );
  }
}
