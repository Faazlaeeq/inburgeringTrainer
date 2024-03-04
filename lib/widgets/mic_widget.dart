import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/helpers/speech_listener.dart';
import 'package:inburgering_trainer/logic/mic_cubit.dart';
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
          return FloatingActionButton(
            onPressed: () => listen(context),
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (state is MicInactive) {
          return FloatingActionButton(
            onPressed: () => listen(context),
            child: const Icon(Icons.mic),
          );
        }
        if (state is MicError) {
          return FloatingActionButton(
            onPressed: () => listen(context),
            child: const Icon(Icons.error),
          );
        }
        return FloatingActionButton(
          onPressed: () async => listen(context),
          child: const Icon(Icons.mic),
        );
      },
    );
  }
}
