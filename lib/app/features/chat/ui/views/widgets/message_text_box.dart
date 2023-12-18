import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_button.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class MessageInputHandler extends StatefulWidget {
  const MessageInputHandler({required this.recipientId, super.key});

  final String recipientId;
  @override
  State<MessageInputHandler> createState() => _MessageInputHandlerState();
}

class _MessageInputHandlerState extends State<MessageInputHandler> {
  @override
  Widget build(BuildContext context) {
    const isShowing = 5 == 4;

    if (!isShowing) {
      return const VoiceRecorderBox();
    }

    return MessagingTextBox(
      recipientId: widget.recipientId,
    );
  }
}

class MessagingTextBox extends StatefulWidget {
  const MessagingTextBox({required this.recipientId, super.key});

  final String recipientId;

  @override
  State<MessagingTextBox> createState() => _MessagingTextBoxState();
}

class _MessagingTextBoxState extends State<MessagingTextBox>
    with WidgetsBindingObserver {
  double _bottomOffset = 50;
  late String _recipientId;

  final controller = TextEditingController();
  bool showRecordingIcon = false;

  @override
  void initState() {
    _recipientId = widget.recipientId;
    WidgetsBinding.instance.addObserver(this);
    controller.addListener(onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    moveTextBoxPositionOnKeyboardShow();
    super.didChangeMetrics();
  }

  void onTextChanged() {
    if (controller.text.isEmpty) {
      setState(() {
        showRecordingIcon = false;
      });
    } else {
      setState(() {
        showRecordingIcon = true;
      });
    }
  }

  void moveTextBoxPositionOnKeyboardShow() {
    final keyboardHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      // prevent textfield from reaching the bottom on keyboard hide
      if (keyboardHeight < 50) {
        _bottomOffset = 50;
      } else {
        _bottomOffset = context.height * 0.4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sendMessageCubit = context.read<SendMessageCubit>();
    final currentUser = context.read<AuthenticationCubit>().user;

    void sendMessage() {
      if (controller.text.isNotEmpty) {
        sendMessageCubit.sendMessage(
          message: Message(
            senderId: currentUser.id,
            recipientId: _recipientId,
            message: controller.text,
          ),
        );
        controller.clear();
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: _bottomOffset),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 3,
                  sigmaY: 3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        // onChanged: (text) => message = text,
                        // controller: TextEditingController(),
                        maxLines: null,
                        enabled: true,
                        // expands: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          // fillColor: AppColors.lightGrey3,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              width: 0,
                              color: Colors.transparent,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: 'new message',
                        ),
                      ),
                    ),
                    const Gap(12),
                    if (showRecordingIcon) ...[
                      MessageButton(
                        onPressed: sendMessage,
                        icon: FontAwesomeIcons.paperPlane,
                      ),
                    ] else ...[
                      MessageButton(
                        onPressed: () {},
                        icon: FontAwesomeIcons.microphone,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceRecorderBox extends StatefulWidget {
  const VoiceRecorderBox({super.key});

  @override
  State<VoiceRecorderBox> createState() => _VoiceRecorderBoxState();
}

class _VoiceRecorderBoxState extends State<VoiceRecorderBox> {
  bool isRecording = true;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      MessageButton(
                        onPressed: () {
                          // close recorder ui
                        },
                        icon: FontAwesomeIcons.xmark,
                      ),
                      SizedBox(
                        width: context.width * 0.58,
                        child: const LinearProgressIndicator(
                          minHeight: 2,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MessageButton(
                      onPressed: () {},
                      icon: FontAwesomeIcons.arrowUp,
                    ),
                    const Gap(8),
                    MessageButton(
                      onPressed: () {
                        // toggle stop/play
                        if (isRecording) {
                          setState(() {
                            isRecording = !isRecording;
                          });
                        } else {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }
                      },
                      icon: isRecording
                          ? Icons.stop_circle
                          : (isPlaying ? Icons.pause_circle : Icons.play_arrow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
