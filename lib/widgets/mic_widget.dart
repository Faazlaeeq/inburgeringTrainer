import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:inburgering_trainer/logic/bloc/speech_bloc.dart';

import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class MicWidget extends StatefulWidget {
  SpeechListner sl;
  MicWidget({super.key, required this.sl});

  @override
  State<MicWidget> createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget> {
  void listen(BuildContext ctx) {
    widget.sl.startListening();
  }

  @override
  void initState() {
    widget.sl.speechInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MicCubit, MicState>(
      builder: (context, state) {
        if (state is MicActive) {
          return AvatarGlow(
              animate: true,
              glowCount: 1,
              glowRadiusFactor: 0.5,
              glowColor: MyColors.primaryColor,
              duration: const Duration(milliseconds: 2000),
              startDelay: const Duration(milliseconds: 100),
              repeat: true,
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: const ImageIcon(
                  AssetImage("assets/icons/micicon.png"),
                  size: 50,
                  color: MyColors.whiteColor,
                ),
              ));
        }

        if (state is MicInactive) {
          return Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(50)),
            child: const ImageIcon(
              AssetImage("assets/icons/micicon.png"),
              size: 50,
              color: MyColors.whiteColor,
            ),
          );
        }
        if (state is MicError) {
          return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(50)),
            child: const Icon(
              Icons.error,
              color: MyColors.whiteColor,
              size: 50,
            ),
          );
        }
        return Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: MyColors.primaryColor,
              borderRadius: BorderRadius.circular(50)),
          child: const ImageIcon(
            AssetImage("assets/icons/micicon.png"),
            size: 30,
            color: MyColors.whiteColor,
          ),
        );
      },
    );
  }
}
