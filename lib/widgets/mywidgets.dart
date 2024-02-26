import 'package:inburgering_trainer/lib/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:flutter/cupertino.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
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
            const Center(
              child: Text(
                'This is a card',
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  "1/8",
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
