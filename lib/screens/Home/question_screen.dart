import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/cubits/question_cubit.dart';
import 'package:inburgering_trainer/repository/question_repository.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';

import '../../utils/imports.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    questionCubit.getQuestions(exerciseId: widget.exerciseId);
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
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress (2/8)",
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: MyColors.lightBlackColor, fontSize: 14),
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
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
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
                ImagesInRow(questionCubit: questionCubit),
                const SizedBox(
                  height: padding2,
                ),
                SizedBox(
                  width: width(context),
                  child: TextButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        barrierColor: const Color.fromRGBO(0, 0, 0, 0.6),
                        builder: (BuildContext context) {
                          return BlocBuilder<QuestionCubit, QuestionState>(
                            bloc: questionCubit,
                            builder: (context, state) {
                              if (state is QuestionLoaded) {
                                return ModalFromBottom(
                                  title: "Question Text",
                                  data: [
                                    //TODO:make index dynamic

                                    ModalContent(
                                        title: "Actual Question",
                                        content: state.questions[0].questionData
                                            .questionText),
                                  ],
                                );
                              }
                              return const CupertinoActivityIndicator();
                            },
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
                  style: TextStyle(color: MyColors.blackColor, fontSize: 14),
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
            )),
          ),
        ));
  }
}

class ImagesInRow extends StatelessWidget {
  const ImagesInRow({
    super.key,
    required this.questionCubit,
  });

  final QuestionCubit questionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      bloc: questionCubit,
      builder: (context, state) {
        return Container(
          padding: paddingSymmetricVertical3,
          width: width(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (state is QuestionLoaded) ...[
                Container(
                  height: 106,
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const CupertinoActivityIndicator(),
                      state.questions[0].questionData.imageURLs[0]),
                ),
                Container(
                  height: 106,
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const CupertinoActivityIndicator(),
                      state.questions[0].questionData.imageURLs[1]),
                )
              ],
              if (state is QuestionLoading || state is QuestionInitial) ...[
                Container(
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  height: 106,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CupertinoActivityIndicator(),
                ),
                Container(
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CupertinoActivityIndicator(),
                ),
              ],
              if (state is QuestionError) ...[
                Container(
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  height: 106,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyColors.outlineColor, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error,
                        color: MyColors.primaryColor,
                        size: 40,
                      ),
                      Text(
                        state.message,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                color: MyColors.primaryColor, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: paddingAll0,
                  width: width(context) / 2.2,
                  height: 106,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyColors.outlineColor, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error,
                        color: MyColors.primaryColor,
                        size: 40,
                      ),
                      Text(
                        state.message,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                                color: MyColors.primaryColor, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class modalFromBottom extends StatelessWidget {
  const modalFromBottom({
    super.key,
    required this.widget,
  });

  final QuestionScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) / 4,
      width: width(context),
      color: CupertinoColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.title,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: MyColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CupertinoButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
