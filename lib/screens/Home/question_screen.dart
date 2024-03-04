import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/sizes.dart';
import 'package:inburgering_trainer/widgets/mywidgets.dart';

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
  // QuestionCubit questionCubit = QuestionCubit(QuestionRepository());
  late AudioCubit _audioCubit;

  @override
  void initState() {
    _audioCubit = context.read<AudioCubit>();
    context.read<QuestionCubit>().getQuestions(exerciseId: widget.exerciseId);
    super.initState();
    currentIndex = pageController.initialPage + 1;
  }

  @override
  void dispose() {
    _audioCubit.stopAudio(); // Stop the audio
    super.dispose();
  }

  PageController pageController = PageController(initialPage: 0);
  int? currentIndex;
  final currentPageNotifier = ValueNotifier<int>(1);

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
        child: BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            if (state is QuestionLoaded) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: currentPageNotifier,
                        builder: (context, currentPage, _) {
                          return Text(
                            "Progress ($currentPage/${state.questions.length})",
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                    color: MyColors.lightBlackColor,
                                    fontSize: 14),
                          );
                        },
                      ),
                      Padding(
                        padding: paddingSymmetricVertical2,
                        child: LinearProgressIndicator(
                          value: 0.5,
                          minHeight: 6,
                          backgroundColor: MyColors.outlineColor,
                          valueColor: const AlwaysStoppedAnimation(
                              MyColors.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                            onPageChanged: (index) {
                              currentPageNotifier.value = index + 1;
                              if (context.read<AudioCubit>().state
                                  is AudioPlaying) {
                                context.read<AudioCubit>().stopAudio();
                              }
                            },
                            itemCount: state.questions.length,
                            controller: pageController,
                            itemBuilder: (context, index) {
                              return QuestionPageWidget(
                                index: index,
                              );
                            }),
                      ),
                      const Center(
                          child: Text(
                        "Tap to Speak",
                        style:
                            TextStyle(color: MyColors.blackColor, fontSize: 14),
                      )),
                      Row(
                        children: [
                          MicWidget(),
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
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is QuestionError) {
              return MyErrorWidget(
                message: state.message,
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ));
  }
}

class QuestionPageWidget extends StatelessWidget {
  const QuestionPageWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Please listen to the voice",
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: MyColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: padding1,
        ),
        RichText(
          text: TextSpan(
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  color: MyColors.blackColor,
                  fontSize: 12,
                ),
            children: <TextSpan>[
              const TextSpan(
                  text:
                      'The voice is related to images below. Use the image cues for framing your answer. '),
              TextSpan(
                text: 'More details',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
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
        ImagesInRow(
          index: index,
        ),
        const SizedBox(
          height: padding2,
        ),
        ShowTextWidget(index: index),
        const SizedBox(
          height: padding2,
        ),
        PlayQuestionButton(index: index),
        SizedBox(
          height: height(context) / 8,
        ),
      ],
    );
  }
}
