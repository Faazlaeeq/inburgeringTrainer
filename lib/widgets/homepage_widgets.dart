import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';

class PlayQuestionButton extends StatefulWidget {
  const PlayQuestionButton(
      {super.key,
      this.iconSize = 72,
      required this.index,
      this.isQuestion = true});
  final double iconSize;
  final int index;
  final bool isQuestion;

  @override
  State<PlayQuestionButton> createState() => _PlayQuestionButtonState();
}

class _PlayQuestionButtonState extends State<PlayQuestionButton> {
  late AudioCubit audioCubit;

  @override
  void initState() {
    debugPrint('PlayQuestionButton initState called');
    if (widget.isQuestion) {
      QuestionState state = context.read<QuestionCubit>().state;
      audioCubit = context.read<AudioCubit>();
      AudioState audioState = audioCubit.state;

      if (state is QuestionLoaded &&
          (audioState is AudioInitial ||
              audioState is AudioStopped ||
              audioState is AudioPaused)) {
        if (widget.isQuestion) {
          context.read<AudioCubit>().playAudio(
              state.questions[widget.index].questionData.questionSound,
              state.questions[widget.index].id);
        }
      } else if (state is QuestionLoaded && (audioState is AudioPlaying)) {
        context.read<AudioCubit>().stopAudio().then((value) => context
            .read<AudioCubit>()
            .playAudio(state.questions[widget.index].questionData.questionSound,
                state.questions[widget.index].id));
      }
    } else {
      QuestionState state = context.read<QuestionCubit>().state;
      audioCubit = context.read<AudioCubit>();
      AudioState audioState = audioCubit.state;
      if (state is QuestionLoaded && (audioState is AudioPlaying)) {
        context.read<AudioCubit>().stopAudio();
      }
      audioCubit = AudioCubit();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.isQuestion) {
      audioCubit.stopAudio();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            return BlocBuilder<AudioCubit, AudioState>(
                bloc: audioCubit,
                builder: (context, audioState) {
                  Widget icon;

                  QuestionState state = context.read<QuestionCubit>().state;

                  if (state is QuestionLoading ||
                      state is QuestionInitial ||
                      state is QuestionError) {
                    return const SizedBox();
                  } else if (audioState is AudioStopped) {
                    icon = ImageIcon(
                      const AssetImage('assets/icons/speak.png'),
                      size: widget.iconSize,
                      color: MyColors.blackLightColor,
                    );
                  } else if (audioState is AudioPlaying) {
                    icon = StreamBuilder<Duration>(
                        stream: audioCubit.audioPosition,
                        builder: (context, snapshot) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: widget.iconSize,
                                height: widget.iconSize,
                                child: CircularProgressIndicator(
                                  value: (snapshot.data != null &&
                                          audioState.duration != null)
                                      ? snapshot.data!.inMilliseconds /
                                          (audioState.duration!.inMilliseconds)
                                      : 0.0,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.lightBlackColor),
                                ),
                              ),
                              Icon(Icons.pause,
                                  size: widget.iconSize * 0.6,
                                  color: MyColors.blackLightColor),
                            ],
                          );
                        });
                  } else if (audioState is AudioPaused) {
                    icon = StreamBuilder<Duration>(
                        stream: audioCubit.audioPosition,
                        builder: (context, snapshot) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: widget.iconSize,
                                height: widget.iconSize,
                                child: CircularProgressIndicator(
                                  value: (snapshot.data != null &&
                                          audioState.duration != null)
                                      ? snapshot.data!.inMilliseconds /
                                          (audioState.duration!.inMilliseconds)
                                      : 0.0,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.lightBlackColor),
                                ),
                              ),
                              Icon(Icons.play_arrow,
                                  size: widget.iconSize * 0.6,
                                  color: MyColors.lightBlackColor),
                            ],
                          );
                        });
                  } else if (state is AudioStopped) {
                    icon = ImageIcon(
                      const AssetImage('assets/icons/speak.png'),
                      size: widget.iconSize,
                      color: MyColors.blackLightColor,
                    );
                  } else {
                    icon = widget.isQuestion
                        ? const SizedBox()
                        : ImageIcon(
                            const AssetImage('assets/icons/speak.png'),
                            size: widget.iconSize,
                            color: MyColors.blackLightColor,
                          );
                  }
                  return IconButton(
                    onPressed: () {
                      debugPrint(
                          'AudioCubit state: ${context.read<AudioCubit>().state}');

                      QuestionState state = context.read<QuestionCubit>().state;

                      if ((state is QuestionLoaded) &&
                          (audioState is AudioStopped ||
                              audioState is AudioInitial)) {
                        if (widget.isQuestion) {
                          audioCubit.playAudio(
                              state.questions[widget.index].questionData
                                  .questionSound,
                              state.questions[widget.index].id);
                        } else {
                          audioCubit.playAudio(
                              state.questions[widget.index].questionData
                                  .answerSound,
                              state.questions[widget.index].id);
                        }
                      } else if (state is QuestionLoaded &&
                          audioState is AudioPaused) {
                        audioCubit.resumeAudio();
                      } else if (state is QuestionError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: MyColors.primaryColor,
                        ));
                      } else if ((state is QuestionLoaded) &&
                          audioState is AudioPlaying) {
                        audioCubit.pauseAudio();
                      }
                    },
                    icon: icon,
                  );
                });
          },
        )
      ],
    );
  }
}

class ShowTextWidget extends StatelessWidget {
  const ShowTextWidget(
      {super.key,
      // required this.questionCubit,
      required this.index});

  // final QuestionCubit questionCubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context),
      child: TextButton(
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            barrierColor: const Color.fromRGBO(0, 0, 0, 0.6),
            builder: (BuildContext context) {
              return BlocBuilder<QuestionCubit, QuestionState>(
                builder: (context, state) {
                  if (state is QuestionLoaded) {
                    return ModalFromBottom(
                      buttonAtTop: PlayQuestionButton(
                        iconSize: 40,
                        index: index,
                      ),
                      title: "Question Text",
                      data: [
                        ModalContent(
                            title: "Actual Question",
                            content: state
                                .questions[index].questionData.questionText),
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
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: MyColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ImagesInRow extends StatelessWidget {
  const ImagesInRow({super.key, required this.index
      // required this.questionCubit,
      });

  // final QuestionCubit questionCubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return Container(
          padding: paddingSymmetricVertical2,
          width: width(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is QuestionLoaded) ...[
                BlocListener<MicCubit, MicState>(
                  listener: (context, answerState) {
                    if (answerState is MicText) {
                      context.read<AnswerCubit>().postAnswer(
                          state.questions[index].questionData.questionText,
                          answerState.text,
                          "63d97bb2-5678-47a2-8ebc-b1f84b27e5d6",
                          state.exerciseId,
                          state.questions[index].id,
                          answerState.path);
                    }
                  },
                  child: const SizedBox(),
                ),
                Container(
                  height: height(context) / 6,
                  padding: paddingAll0,
                  margin: paddingSymmetricHorizontal3,
                  width: width(context) / 2.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl:
                          state.questions[index].questionData.imageURLs[0],
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => const Row(
                        children: [
                          Icon(Icons.error),
                          Text(" Can't load Image")
                        ],
                      ),
                      fit: BoxFit.cover,
                      key: UniqueKey(),
                      maxWidthDiskCache: 1000,
                      maxHeightDiskCache: 1000,
                    ),
                  ),
                ),
                if (state.questions[index].questionData.imageURLs.length > 1)
                  Container(
                    height: height(context) / 6,
                    padding: paddingAll0,
                    margin: paddingSymmetricHorizontal3,
                    width: width(context) / 2.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            state.questions[index].questionData.imageURLs[1],
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => const Row(
                          children: [
                            Icon(Icons.error),
                            Text(" Can't load Image")
                          ],
                        ),
                        fit: BoxFit.cover,
                        key: UniqueKey(),
                        maxWidthDiskCache: 1000,
                        maxHeightDiskCache: 1000,
                      ),
                    ),
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
