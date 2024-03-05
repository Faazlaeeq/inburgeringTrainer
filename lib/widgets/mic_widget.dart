import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
import 'package:inburgering_trainer/theme/colors.dart';
import 'package:inburgering_trainer/utils/imports.dart';

class MicWidget extends StatelessWidget {
  MicWidget({super.key});
  final streamController = StreamController<String>.broadcast();

  void listen(BuildContext ctx) {
    final sl = SpeechListner(ctx);
    sl.speechInit();

    // print(reply);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MicCubit, MicState>(
      builder: (context, state) {
        if (state is MicActive) {
          return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () => listen(context),
                icon: const CupertinoActivityIndicator(
                  radius: 15,
                  color: MyColors.whiteColor,
                ),
              ));
        }

        if (state is MicInactive) {
          return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () => listen(context),
                icon: const ImageIcon(
                  AssetImage("assets/icons/micicon.png"),
                  size: 50,
                  color: MyColors.whiteColor,
                ),
              ));
        }
        if (state is MicError) {
          return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () => listen(context),
                icon: const Icon(
                  Icons.error,
                  color: MyColors.whiteColor,
                  size: 50,
                ),
              ));
        }
        return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              onPressed: () => listen(context),
              icon: const ImageIcon(
                AssetImage("assets/icons/micicon.png"),
                size: 50,
                color: MyColors.whiteColor,
              ),
            ));
      },
    );
  }
}
