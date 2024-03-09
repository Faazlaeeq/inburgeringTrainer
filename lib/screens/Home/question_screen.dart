import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/io.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/audio_cubit.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';
import 'package:inburgering_trainer/logic/cubit/activity_cubit.dart';
import 'package:inburgering_trainer/logic/cubit/answer_cubit.dart';
import 'package:inburgering_trainer/logic/helpers/record_helper.dart';
import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/logic/question_cubit.dart';
import 'package:inburgering_trainer/models/question_model.dart';
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
  // late AnswerCubit _answerCubit;
  late ActivityCubit _activityCubit;
  late MicCubit _micCubit;
  String? audioPath;
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    _audioCubit = context.read<AudioCubit>();
    // _answerCubit = context.read<AnswerCubit>();
    _micCubit = context.read<MicCubit>();
    _activityCubit = context.read<ActivityCubit>();
    context.read<QuestionCubit>().getQuestions(exerciseId: widget.exerciseId);
    super.initState();
    currentIndex = pageController.initialPage + 1;
  }

  @override
  void dispose() {
    _audioCubit.stopAudio();
    // _answerCubit.clearAnswer();
    _micCubit.micInitial();
    _activityCubit.fetchActivity();
    super.dispose();
  }

  PageController pageController = PageController(initialPage: 0);
  int? currentIndex;
  final currentPageNotifier = ValueNotifier<int>(1);
  bool showPlayer = false;

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
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Progress ($currentPage/${state.questions.length})",
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                          color: MyColors.lightBlackColor,
                                          fontSize: 14),
                                ),
                                Padding(
                                  padding: paddingSymmetricVertical2,
                                  child: LinearProgressIndicator(
                                    value: currentPage / state.questions.length,
                                    minHeight: 6,
                                    backgroundColor: MyColors.outlineColor,
                                    valueColor: const AlwaysStoppedAnimation(
                                        MyColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              ]);
                        },
                      ),
                      Expanded(
                        child: PageView.builder(
                            onPageChanged: (index) async {
                              currentPageNotifier.value = index + 1;
                              if (context.read<AudioCubit>().state
                                  is AudioPlaying) {
                                context.read<AudioCubit>().stopAudio();
                              }
                            },
                            itemCount: state.questions.length,
                            controller: pageController,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: QuestionPageWidget(
                                  index: index,
                                  questionId: state.questions[index].id,
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: padding2,
                      ),
                      PageChangeButtons(
                          state: state,
                          currentIndex: currentIndex,
                          pageController: pageController),
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

class PageChangeButtons extends StatelessWidget {
  const PageChangeButtons({
    super.key,
    required this.currentIndex,
    required this.pageController,
    required this.state,
  });

  final int? currentIndex;
  final PageController pageController;
  final QuestionLoaded state;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: MyColors.whiteColor,
          border:
              Border(top: BorderSide(color: MyColors.outlineColor, width: 1))),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (currentIndex! > 0) {
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MyColors.primaryColor,
                size: 20,
              )),
          const Spacer(),
          IconButton(
              onPressed: () {
                if (currentIndex! < state.questions.length) {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: MyColors.primaryColor,
                size: 20,
              )),
        ],
      ),
    );
  }
}

class QuestionPageWidget extends StatefulWidget {
  const QuestionPageWidget(
      {super.key, required this.index, required this.questionId});
  final int index;
  final String questionId;

  @override
  State<QuestionPageWidget> createState() => _QuestionPageWidgetState();
}

class _QuestionPageWidgetState extends State<QuestionPageWidget> {
  late MicCubit micCubit;
  late SpeechBloc speechBloc;

  late SpeechListner sl;
  @override
  void initState() {
    micCubit = context.read<MicCubit>();
    speechBloc = context.read<SpeechBloc>();
    sl = SpeechListner(speechBloc: speechBloc, micCubit: micCubit);

    sl.speechInit();
    super.initState();
  }

  @override
  void dispose() {
    micCubit.micInitial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnswerCubit(id: widget.questionId.toString()),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height(context) / 1.33),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                          debugPrint('More details tapped');
                          // Navigate or do something else
                        },
                    ),
                  ],
                ),
              ),
              ImagesInRow(
                index: widget.index,
              ),
              const SizedBox(
                height: padding2,
              ),
              ShowTextWidget(index: widget.index),
              const SizedBox(
                height: padding2,
              ),
              PlayQuestionButton(index: widget.index),
              const SizedBox(
                height: padding2,
              ),
              const Spacer(),
              BlocBuilder<AnswerCubit, AnswerState>(
                builder: (context, state) {
                  if (state is AnswerInitial) {
                    return Column(
                      children: [
                        const Center(
                            child: Text(
                          "Tap to Speak",
                          style: TextStyle(
                              color: MyColors.blackColor, fontSize: 14),
                        )),
                        TextButton(
                            onPressed: () {
                              SpeechBloc speechBloc =
                                  context.read<SpeechBloc>();
                              MicCubit micCubit = context.read<MicCubit>();
                              SpeechListner(
                                      speechBloc: speechBloc,
                                      micCubit: micCubit)
                                  .startListening();
                            },
                            child: MicWidget(
                              sl: sl,
                            )),
                      ],
                    );
                  } else {
                    // context.read<ActivityCubit>().fetchActivity();
                    return YourAnswerWidget(index: widget.index);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
