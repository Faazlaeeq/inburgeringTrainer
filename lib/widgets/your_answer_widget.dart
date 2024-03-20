import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/cubit/player_cubit.dart';
import 'package:inburgering_trainer/logic/helpers/sound_helper.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/screens/Home/chat_bubble.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/homepage_widgets.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';
import 'package:path_provider/path_provider.dart';

class YourAnswerWidget extends StatefulWidget {
  const YourAnswerWidget({super.key, required this.index, required this.sl});
  final int index;
  final SoundHelper sl;
  @override
  State<YourAnswerWidget> createState() => _YourAnswerWidgetState();
}

class _YourAnswerWidgetState extends State<YourAnswerWidget> {
  @override
  void initState() {
    super.initState();
  }

  String audioFilepathWorking =
      "/data/user/0/com.example.inburgering_trainer/app_flutter/recording1429929f-c4c5-40be-97b2-591ba8de92e6.m4a";
  String audioFilepath =
      "/storage/emulated/0/Android/data/com.example.inburgering_trainer/files/audio_1710755792262.m4a";
  @override
  Widget build(BuildContext context) {
    // String path =
    //     "/storage/emulated/0/Android/data/com.example.inburgering_trainer/files/audio_1710755792262.m4a";
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
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
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                BlocBuilder<AnswerCubit, AnswerState>(
                    builder: (context, state) {
                  if (state is AnswerLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else if (state is AnswerLoaded) {
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: height(context) * 0.16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PlayUserAnswerButton(path: state.path),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding3, vertical: padding1),
                                child: Text(
                                  // "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                  state.userAnswer!,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                          color: MyColors.blackColor,
                                          fontSize: 12),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is AnswerError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(color: MyColors.blackColor, fontSize: 14),
                        softWrap: true,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                Container(
                  height: 35,
                  decoration: const BoxDecoration(
                      color: MyColors.accentColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: TextButton(
                      onPressed: () {
                        context.read<AnswerCubit>().clearAnswer();
                        MicCubit micCubit = context.read<MicCubit>();
                        micCubit.micInitial();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh,
                              color: MyColors.darkPrimaryColor),
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
          AnswerOptionsWidget(index: widget.index),
        ],
      ),
    );
  }
}

class PlayUserAnswerButton extends StatefulWidget {
  const PlayUserAnswerButton({
    super.key,
    required this.path,
  });
  final String path;

  @override
  State<PlayUserAnswerButton> createState() => _PlayUserAnswerButtonState();
}

class _PlayUserAnswerButtonState extends State<PlayUserAnswerButton> {
  bool playing = false;
  Directory? appDirectory;
  @override
  void initState() {
    getDir();
    super.initState();
  }

  void getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerCubit(),
      child: (appDirectory != null)
          ? WaveBubble(
              path: widget.path,
              isSender: true,
              appDirectory: appDirectory!,
            )
          : const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}

class AnswerOptionsWidget extends StatelessWidget {
  AnswerOptionsWidget({super.key, required this.index});
  final int index;
  final AudioCubit audioCubit = AudioCubit();
  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    return Container(
      decoration: const BoxDecoration(color: MyColors.whiteColor),
      padding: paddingSymmetricHorizontal1,
      child: Row(
        children: [
          SizedBox(
            width: width(buildContext) * 0.45,
            height: 36,
            child: CupertinoButton(
              padding: paddingSymmetricHorizontal2,
              color: MyColors.primaryColor,
              minSize: 10,
              child: const Text("Correct Answer"),
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
            width: width(buildContext) * 0.45,
            height: 36,
            child: CupertinoButton.filled(
              padding: paddingSymmetricHorizontal2,
              minSize: 10,
              child: const Text("AI Feedback"),
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
