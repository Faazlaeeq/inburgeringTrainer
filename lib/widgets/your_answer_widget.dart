import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/helpers/tts_helper.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/homepage_widgets.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';
import 'package:inburgering_trainer/widgets/music_visualizer.dart';
import 'package:lottie/lottie.dart';

class YourAnswerWidget extends StatefulWidget {
  const YourAnswerWidget({super.key, required this.index, required this.sl});
  final int index;
  final SpeechListner sl;

  @override
  State<YourAnswerWidget> createState() => _YourAnswerWidgetState();
}

class _YourAnswerWidgetState extends State<YourAnswerWidget> {
  @override
  void initState() {
    TtsHelper().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: paddingAll2,
                  child: BlocBuilder<AnswerCubit, AnswerState>(
                      builder: (context, state) {
                    if (state is AnswerLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else if (state is AnswerLoaded) {
                      return ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: height(context) * 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (state.userAnswer != null)
                              PlayUserAnswerButton(
                                state: state,
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is AnswerError) {
                      return Text(
                        state.error,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(color: MyColors.blackColor, fontSize: 14),
                        softWrap: true,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
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
                        // SpeechBloc speechBloc = context.read<SpeechBloc>();
                        // MicCubit micCubit = context.read<MicCubit>();
                        widget.sl.startListening();
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
    required this.state,
  });
  final AnswerLoaded state;

  @override
  State<PlayUserAnswerButton> createState() => _PlayUserAnswerButtonState();
}

class _PlayUserAnswerButtonState extends State<PlayUserAnswerButton> {
  bool playing = false;
  TtsHelper tts = TtsHelper();

  final List<Color> colors = [
    MyColors.darkPrimaryColor,
    MyColors.primaryColor,
    MyColors.accentColor,
    MyColors.primaryColor,
    MyColors.darkPrimaryColor
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  late MusicVisualizer visualizer;
  final visualComponentKey = GlobalKey<MusicVisualizerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    visualizer = MusicVisualizer();
    tts.flutterTts.setCompletionHandler(() {
      setState(() {
        playing = false;
        visualComponentKey.currentState?.stopAnimation();
      });
    });

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColors.lightGrey,
          border: Border.all(color: MyColors.outlineColor2)),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (playing) {
                  tts.flutterTts.stop();

                  setState(() {
                    playing = false;
                    visualComponentKey.currentState?.stopAnimation();
                  });
                } else {
                  if (widget.state.userAnswer != null) {
                    tts.speak(widget.state.userAnswer!);
                    setState(() {
                      playing = true;
                      visualComponentKey.currentState?.startAnimation();
                    });
                  }
                }
              },
              enableFeedback: false,
              padding: paddingAll1,
              icon: Container(
                padding: paddingAll1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: MyColors.primaryColor,
                ),
                child: Icon(
                  playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: MyColors.bgColor,
                  size: 20,
                ),
              )),
          SizedBox(
              width: width(context) * 0.7,
              height: 20,
              child: playing
                  ? Lottie.asset("assets/icons/waveAnimation.json",
                      fit: BoxFit.cover)
                  : Image.asset(
                      "assets/icons/disabledWave.png",
                      fit: BoxFit.cover,
                    ))
        ],
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
