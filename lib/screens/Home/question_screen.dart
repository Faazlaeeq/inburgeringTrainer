import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/cubits/question_cubit.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';

import '../../utils/imports.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(
      {super.key, required this.title, required this.exerciseId});
  final String title;
  final String exerciseId;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  QuestionCubit questionCubit = QuestionCubit(QuestionRepository());
  @override
  void initState() {
    questionCubit.getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text(widget.title,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: MyColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            automaticallyImplyLeading: true,
            transitionBetweenRoutes: true,
            border: Border.all(color: MyColors.bgColor, width: 0),
            backgroundColor: MyColors.bgColor,
            padding: const EdgeInsetsDirectional.only(
                start: padding1, end: 0, top: padding1, bottom: padding2),
            leading: IconButton(
              icon: const ImageIcon(
                AssetImage('assets/icons/cross.png'),
                color: MyColors.blackColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding2),
          child: SingleChildScrollView(
            child: BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Progress (2/8)",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                              color: MyColors.lightBlackColor, fontSize: 14),
                    ),
                    Padding(
                      padding: paddingSymmetricVertical2,
                      child: LinearProgressIndicator(
                        value: 0.5,
                        minHeight: 6,
                        backgroundColor: MyColors.outlineColor,
                        valueColor:
                            const AlwaysStoppedAnimation(MyColors.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please listen to the voice",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                              color: MyColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: padding1,
                    ),
                    RichText(
                      text: TextSpan(
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: MyColors.blackColor,
                              fontSize: 12,
                            ),
                        children: <TextSpan>[
                          const TextSpan(
                              text:
                                  'The voice is related to images below. Use the image cues for framing your answer. '),
                          TextSpan(
                            text: 'More details',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ), // Change color
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('More details tapped');
                                // Navigate or do something else
                              },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: paddingSymmetricVertical3,
                      width: width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: paddingAll0,
                            width: width(context) / 2.2,
                            child: Image.asset(
                              "assets/images/pic1.png",
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          Container(
                            padding: paddingAll0,
                            width: width(context) / 2.2,
                            child: Image.asset(
                              "assets/images/pic2.png",
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: padding2,
                    ),
                    SizedBox(
                      width: width(context),
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 200, // You can adjust this as needed
                                child: Center(
                                  child: Text('Hello, World!'),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Show Text',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: padding2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const ImageIcon(
                              AssetImage('assets/icons/speak.png'),
                              size: 72,
                              color: MyColors.blackColor,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: height(context) / 8,
                    ),
                    const Center(
                        child: Text(
                      "Tap to Speak",
                      style:
                          TextStyle(color: MyColors.blackColor, fontSize: 14),
                    )),
                    Center(
                      child: IconButton(
                          onPressed: () {},
                          icon: const Image(
                            image: AssetImage('assets/icons/mic.png'),
                            width: 100,
                            height: 100,
                          )),
                    ),
                  ],
                );
              },
            ),
          ),
        )));
  }
}
