import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/text_voice_toggler_cubit/text_voice_toggler_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/voice_note_cubit/voice_note_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_button.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class VoiceRecorderBox extends StatefulWidget {
  const VoiceRecorderBox({
     required this.audioPlayer, this.recipientId,
     this.conversationId,
    super.key,
  });

  /// A null recipientId just indirectly tells us treat as group chat
  final String? recipientId;
  final String? conversationId;

  /// AudioPlayer object is a required parameter here
  /// so that the parent widget [TextVoiceBoxToggler] can
  /// handle it's [AudioPlayer] disposal.
  final AudioPlayer audioPlayer;

  @override
  State<VoiceRecorderBox> createState() => _VoiceRecorderBoxState();
}

class _VoiceRecorderBoxState extends State<VoiceRecorderBox> {
  late AudioPlayer _audioPlayer;

  void _playToneOnStartRecord() {
    _audioPlayer.play(
      AssetSource(
        'sounds/start-recording.mp3',
      ),
      volume: 0.3,
    );
  }

  void _playToneOnCancelRecord() {
    _audioPlayer.play(
      AssetSource('sounds/cancel-recording.mp3'),
      volume: 0.3,
    );
  }

  @override
  void initState() {
    _audioPlayer = widget.audioPlayer;
    HapticFeedback.lightImpact();
    _playToneOnStartRecord();
    super.initState();
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
                        CustomCircularIconButton(
                          onPressed: () {
                            _playToneOnCancelRecord();
                            textOrVoiceController.textVoiceToggle();
                          },
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
                  _RecorderControls(
                    recipientId: widget.recipientId,
                    conversationId: widget.conversationId,
                  ),
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
  const _RecorderControls({
    required this.recipientId,
    required this.conversationId,
  });
  // A null recipientId just indirectly tells us that this is a group chat
  final String? recipientId;
  final String? conversationId;

  @override
  State<_RecorderControls> createState() => _RecorderControlsState();
}

class _RecorderControlsState extends State<_RecorderControls> {
  late MinChatUser user;
  late SendMessageCubit sendMessageCubit;
  late TextVoiceTogglerCubit textVoiceTogglerCubit;

  final AudioPlayer _audioPlayer = AudioPlayer();

  late VoiceNoteCubit voiceCubit;

  @override
  void initState() {
    voiceCubit = context.read<VoiceNoteCubit>();
    user = context.read<AuthenticationCubit>().state.user;
    sendMessageCubit = context.read<SendMessageCubit>();
    textVoiceTogglerCubit = context.read<TextVoiceTogglerCubit>();
    _startRecording();
    super.initState();
  }

  void _startRecording() {
    // cause a small delay before starting recorder
    // so that the recorder start sound doesn't
    // seep into the actual recording
    Future.delayed(
      const Duration(milliseconds: 500),
      () => voiceCubit.startRecording(),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceNoteCubit, VoiceNoteState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        final isRecording = state is RecordingState;
        final isPlaying = state is PlaybackState &&
            state is! PlaybackCompleteState &&
            state is! PlaybackStoppedState;

        BaseMessage message;

        final isGroupChat = widget.recipientId == null;

        if (widget.recipientId != null) {
          message = Message(
            senderId: user.id,
            recipientId: widget.recipientId!,
            message: '🎵 Audio',
            messageType: audioMessageFlag,
          );
        } else {
          message = GroupMessage(
            senderId: user.id,
            recipientId: '',
            message: '🎵 Audio',
            senderInfo: user,
            messageType: audioMessageFlag,
          );
        }

        return Container(
          height: 100,
          width: 45,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadiusDirectional.horizontal(
              start: Radius.circular(20),
              end: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCircularIconButton(
                onPressed: () {
                  /// stop voice recording before sending
                  /// only if recorder is still recording
                  /// else, just send
                  if (isRecording) {
                    voiceCubit.stopRecording().then(
                          (_) => _sendVoiceNote(
                            message: message,
                            isGroupChat: isGroupChat,
                          ),
                        );
                  } else {
                    _sendVoiceNote(
                      message: message,
                      isGroupChat: isGroupChat,
                    );
                  }
                },
                icon: FontAwesomeIcons.arrowUp,
              ),
              const Gap(8),
              CustomCircularIconButton(
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
          ),
        );
      },
    );
  }

  void _playToneOnSendRecord() {
    _audioPlayer.play(
      AssetSource('sounds/send-recording.wav'),
      volume: 0.3,
    );
  }

  void _sendVoiceNote({
    required BaseMessage message,
    required bool isGroupChat,
  }) {
    _playToneOnSendRecord();

    if (!isGroupChat) {
      sendMessageCubit.sendVoiceMessage(
        message: message as Message,
        filePath: voiceCubit.path!,
      );
    } else {
      sendMessageCubit.sendGroupVoiceMessage(
        message: message as GroupMessage,
        filePath: voiceCubit.path!,
        id: widget.conversationId!,
      );
    }

    textVoiceTogglerCubit.textVoiceToggle();
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
