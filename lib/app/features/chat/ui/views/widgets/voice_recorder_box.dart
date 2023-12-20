import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/features/chat/ui/cubits/text_voice_toggler_cubit/text_voice_toggler_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/voice_note_cubit/voice_note_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_button.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class VoiceRecorderBox extends StatefulWidget {
  const VoiceRecorderBox({super.key});

  @override
  State<VoiceRecorderBox> createState() => _VoiceRecorderBoxState();
}

class _VoiceRecorderBoxState extends State<VoiceRecorderBox> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textOrVoiceController = context.read<TextVoiceTogglerCubit>();
    
    return BlocProvider(
      create: (context) => VoiceNoteCubit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          margin: const EdgeInsets.only(bottom: 20),
          duration: const Duration(milliseconds: 100),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: ClipRect(
              clipBehavior: Clip.antiAlias,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: context.width * 0.76,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadiusDirectional.horizontal(
                        start: Radius.circular(20),
                        end: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // close recorder
                        MessageButton(
                          onPressed: textOrVoiceController.textVoiceToggle,
                          icon: FontAwesomeIcons.xmark,
                        ),

                        const _RecordingIndicator(),

                        // BlocBuilder<VoiceNoteCubit, VoiceNoteState>(
                        //   builder: (context, state) {
                        //     if (state is RecordingState) {
                        //       return const _RecordingIndicator();
                        //     } else {
                        //       return const _PlaybackIndicator();
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // controls
                  const _RecorderControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecorderControls extends StatefulWidget {
  const _RecorderControls();

  @override
  State<_RecorderControls> createState() => _RecorderControlsState();
}

class _RecorderControlsState extends State<_RecorderControls> {
  // bool isRecording = false;
  // bool isPlaying = false;
  late VoiceNoteCubit cubit;

  @override
  void initState() {
    cubit = context.read<VoiceNoteCubit>();
    cubit.startRecording();
    super.initState();
  }

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceNoteCubit, VoiceNoteState>(
      // listener: (context, state) {
      //   // isRecording = state is RecordingState;
      //   // isPlaying =
      // },
      listener: (ctx, state) {},
      builder: (ctx, state) {
        final voiceCubit = cubit;
        final isRecording = state is RecordingState;
        final isPlaying = state is PlaybackState &&
            state is! PlaybackCompleteState &&
            state is! PlaybackStoppedState;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MessageButton(
              onPressed: () {},
              icon: FontAwesomeIcons.arrowUp,
            ),
            const Gap(8),
            MessageButton(
              onPressed: () => isRecording
                  ? voiceCubit.stopRecording()
                  : isPlaying
                      ? voiceCubit.pausePlayback()
                      : voiceCubit.playback(),

              icon: isRecording
                  ? Icons.stop_circle
                  : (isPlaying ? Icons.pause_circle : Icons.play_arrow),
            ),
          ],
        );
      },
    );
  }
}

class _PlaybackIndicator extends StatelessWidget {
  const _PlaybackIndicator();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _RecordingIndicator extends StatelessWidget {
  const _RecordingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.58,
      child: const LinearProgressIndicator(
        minHeight: 2,
        color: Colors.black,
      ),
    );
  }
}
