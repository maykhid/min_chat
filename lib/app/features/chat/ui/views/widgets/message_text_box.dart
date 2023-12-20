import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/text_voice_toggler_cubit/text_voice_toggler_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_button.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/voice_recorder_box.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class TextVoiceBoxToggler extends StatefulWidget {
  const TextVoiceBoxToggler({required this.recipientId, super.key});

  final String recipientId;
  @override
  State<TextVoiceBoxToggler> createState() => _TextVoiceBoxTogglerState();
}

class _TextVoiceBoxTogglerState extends State<TextVoiceBoxToggler> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextVoiceTogglerCubit(),
      child: BlocBuilder<TextVoiceTogglerCubit, TextVoiceTogglerState>(
        builder: (context, state) {
          final isShowingText = state is TextState;

          if (isShowingText) {
            return MessagingTextBox(
              recipientId: widget.recipientId,
            );
          }
          return const VoiceRecorderBox();
        },
      ),
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
    final textOrVoiceController = context.read<TextVoiceTogglerCubit>();

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
                    // text field
                    _MessageTextField(controller: controller),

                    const Gap(12),

                    if (showRecordingIcon) ...[
                      MessageButton(
                        onPressed: sendMessage,
                        icon: FontAwesomeIcons.paperPlane,
                      ),
                    ] else ...[
                      MessageButton(
                        onPressed: () => print('Tap and hold to record'),
                        onLongPress: textOrVoiceController.textVoiceToggle,
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

class _MessageTextField extends StatelessWidget {
  const _MessageTextField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
