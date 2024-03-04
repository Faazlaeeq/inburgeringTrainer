import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/modal_from_bottom.dart';

class PlayQuestionButton extends StatelessWidget {
  const PlayQuestionButton(
      {super.key, this.iconSize = 72, required this.index});
  final double iconSize;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            return BlocBuilder<AudioCubit, AudioState>(
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
                  size: iconSize,
                  color: MyColors.blackColor,
                );
              } else if (audioState is AudioPlaying) {
                icon = Icon(Icons.pause_circle_outline_rounded,
                    size: iconSize, color: MyColors.blackColor);
              } else if (audioState is AudioPaused) {
                icon = Icon(Icons.play_circle_outline_rounded,
                    size: iconSize, color: MyColors.blackColor);
              } else {
                icon = ImageIcon(
                  const AssetImage('assets/icons/speak.png'),
                  size: iconSize,
                  color: MyColors.blackColor,
                );
              }
              return IconButton(
                onPressed: () {
                  print(
                      'AudioCubit state: ${context.read<AudioCubit>().state}');

                  QuestionState state = context.read<QuestionCubit>().state;

                  if ((state is QuestionLoaded) &&
                      (audioState is AudioStopped ||
                          audioState is AudioInitial)) {
                    context.read<AudioCubit>().playAudio(
                        state.questions[index].questionData.questionSound,
                        state.questions[index].id);
                  } else if (state is QuestionLoaded &&
                      audioState is AudioPaused) {
                    context.read<AudioCubit>().resumeAudio();
                  } else if (state is QuestionError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: MyColors.primaryColor,
                    ));
                  } else if ((state is QuestionLoaded) &&
                      audioState is AudioPlaying) {
                    context.read<AudioCubit>().pauseAudio();
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
                        //TODO:make index dynamic

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
                      state.questions[index].questionData.imageURLs[0]),
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
                      state.questions[index].questionData.imageURLs[1]),
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
