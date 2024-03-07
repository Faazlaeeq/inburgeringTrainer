import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/error_widget.dart';
import 'package:inburgering_trainer/widgets/homepage_widgets.dart';
import 'package:inburgering_trainer/widgets/mic_widget.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';

class YourAnswerWidget extends StatelessWidget {
  const YourAnswerWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Answer",
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        Container(
          margin: paddingAll1,
          decoration: BoxDecoration(
            color: MyColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: MyColors.shadowColor,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: paddingAll2,
                child: BlocBuilder<AnswerCubit, AnswerState>(
                    builder: (context, state) {
                  if (state is AnswerLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (state is AnswerLoaded) {
                    return Text(
                      "${state.userAnswer}",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(color: MyColors.blackColor, fontSize: 14),
                    );
                  } else if (state is AnswerError) {
                    return MyErrorWidget(
                      message: state.error,
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
              Container(
                height: 35,
                decoration: BoxDecoration(
                    color: MyColors.accentColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: TextButton(
                    onPressed: () {
                      context.read<AnswerCubit>().clearAnswer();
                      MicWidget().listen(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: MyColors.darkPrimaryColor),
                        Text("Try Again",
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                    color: MyColors.darkPrimaryColor,
                                    fontWeight: FontWeight.bold))
                      ],
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AnswerOptionsWidget(index: index),
      ],
    );
  }
}

class AnswerOptionsWidget extends StatelessWidget {
  AnswerOptionsWidget({super.key, required this.index});
  final int index;
  AudioCubit audioCubit = AudioCubit();
  @override
  Widget build(BuildContext buildContext) {
    return Container(
      decoration: BoxDecoration(color: MyColors.whiteColor),
      padding: paddingSymmetricHorizontal1,
      child: Row(
        children: [
          SizedBox(
            width: width(buildContext) * 0.42,
            height: 36,
            child: CupertinoButton(
              padding: paddingSymmetricHorizontal2,
              color: MyColors.primaryColor,
              minSize: 10,
              child: Text("Correct Answer"),
              onPressed: () {
                showCupertinoModalPopup(
                    context: buildContext,
                    builder: (context) {
                      return BlocBuilder<QuestionCubit, QuestionState>(
                        bloc: buildContext.read<QuestionCubit>(),
                        builder: (context, state) {
                          if (state is QuestionLoaded) {
                            return ModalFromBottom(
                                buttonAtTop: PlayQuestionButton(
                                  index: index,
                                  iconSize: 40,
                                  isQuestion: false,
                                ),
                                title: "Correct Answer by us (Human Verified)",
                                data: [
                                  ModalContent(
                                      content: state.questions[index]
                                          .questionData.suggestedAnswer)
                                ]);
                          }
                          if (state is QuestionLoading) {
                            return const CupertinoActivityIndicator();
                          } else if (state is QuestionError) {
                            return ModalFromBottom(
                                title: "Correct Answer by us (Human Verified)",
                                data: [ModalContent(content: state.message)]);
                          } else {
                            return ModalFromBottom(
                                title: "Correct Answer by us (Human Verified)",
                                data: [ModalContent(title: state.toString())]);
                          }
                        },
                      );
                    });
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: width(buildContext) * 0.42,
            height: 36,
            child: CupertinoButton.filled(
              padding: paddingSymmetricHorizontal2,
              minSize: 10,
              child: Text("AI Feedback"),
              onPressed: () {
                showCupertinoModalPopup(
                    context: buildContext,
                    builder: (context) {
                      return BlocBuilder<AnswerCubit, AnswerState>(
                        bloc: buildContext.read<AnswerCubit>(),
                        builder: (context, state) {
                          if (state is AnswerLoaded) {
                            return ModalFromBottom(
                                title: "AI Feedback (May Include Errors)",
                                data: [ModalContent(content: state.response)]);
                          }
                          if (state is AnswerLoading) {
                            return const CupertinoActivityIndicator();
                          } else if (state is AnswerError) {
                            return ModalFromBottom(
                                title: "AI Feedback (May Include Errors)",
                                data: [ModalContent(content: state.error)]);
                          } else {
                            return ModalFromBottom(
                                title: "AI Feedback (May Include Errors)",
                                data: [ModalContent(title: state.toString())]);
                          }
                        },
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
