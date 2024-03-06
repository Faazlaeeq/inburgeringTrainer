import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';

class ModalContent {
  final String? title;
  final String? content;

  ModalContent({
    this.title,
    this.content,
  });
}

class ModalFromBottom extends StatelessWidget {
  final Function()? onPressed;
  final Widget? buttonAtTop;

  const ModalFromBottom(
      {super.key,
      this.title,
      this.onPressed,
      required this.data,
      this.buttonAtTop});

  final String? title;
  final List<ModalContent> data;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height(context) / 4,
        maxHeight: height(context) / 2,
        minWidth: width(context),
      ),
      child: Container(
        padding: paddingSymmetricVertical2,
        width: width(context),
        decoration: const BoxDecoration(
            color: MyColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyColors.lightGreyColor),
                height: 4,
                width: width(context) / 4,
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const ImageIcon(AssetImage("assets/icons/cross.png"),
                        color: MyColors.blackColor, size: 12)),
                Text(
                  title ?? "Information",
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            if (buttonAtTop != null) buttonAtTop!,
            Container(
              margin: paddingSymmetricHorizontal1,
              width: double.maxFinite,
              padding: paddingAll2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: data.map((e) {
                    return Container(
                      padding: paddingAll2,
                      color: MyColors.accentColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e.title != null)
                            Text(e.title!,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(e.content ?? "",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: MyColors.primaryColor))
                        ],
                      ),
                    );
                  }).toList()),
            )
          ],
        ),
      ),
    );
  }
}
