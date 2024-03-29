import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/chat_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/chat_time_pill.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_text_box.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/recipient_chat_bubble.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/recipient_voice_bubble.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/sender_chat_bubble.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/sender_voice_bubble.dart';
import 'package:min_chat/core/utils/datetime_x.dart';
import 'package:min_chat/core/utils/participants_x.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class Chats extends StatefulWidget {
  const Chats({required this.conversation, super.key});

  static const String name = '/chats';

  final Conversation conversation;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  late Conversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;
    final recipientUser = _conversation.participants
        .extrapolateParticipantByCurrentUserId(user.id);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            backgroundColor: Colors.white,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: context.pop,
                        child: const FaIcon(FontAwesomeIcons.arrowLeft),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(recipientUser.imageUrl!),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipientUser.name!,
                            // style: AppTextStyles.normalTextStyleDark,
                          ),
                          Text(
                            recipientUser.mID!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            // style: AppTextStyles.normalTextStyleDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: BlocProvider<ChatCubit>(
            create: (context) => ChatCubit()
              ..initMessageListener(
                id: _conversation.documentId!,
              ),
            child: const _ChatsView(),
          ),
        ),

        // messageing text box
        BlocProvider<SendMessageCubit>(
          create: (context) => SendMessageCubit(),
          // for a normal chat the recipient id IS needed
          child: TextVoiceBoxToggler(
            recipientId: recipientUser.id,
            conversation: _conversation,
          ),
        ),
      ],
    );
  }
}

class _ChatsView extends StatefulWidget {
  const _ChatsView();

  @override
  State<_ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<_ChatsView> with WidgetsBindingObserver {
  final controller = ScrollController();

  static const double customScrollExtent = 250;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setNewScrollExtent();
    });
  }

  void setNewScrollExtent({double? scrollExtent}) {
    if (controller.position.atEdge) {
      controller.animateTo(
        controller.position.maxScrollExtent +
            (scrollExtent ??= customScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) {
      incrementScrollExtentOnShowKeyboard();
    }

    super.didChangeMetrics();
  }

  void incrementScrollExtentOnShowKeyboard() {
    final keyboardHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      // trigger reposition/reset of scrollExtent on keyboard hide
      if (keyboardHeight < 50) {
        setNewScrollExtent(scrollExtent: customScrollExtent);
      } else {
        setNewScrollExtent(scrollExtent: context.height * 0.45);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chats = state.chats;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox.expand(
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.only(bottom: 150, top: 30),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                ///? (Logic to show chat time on different days)
                ///
                /// show message and time:
                /// if message[index] is first message
                /// or message[index] timestamp.day is not the same with
                /// message[index - 1] timestamp.day (previous day)
                ///
                /// else:
                /// display other messages
                final isNewDay = index == 0 ||
                    (chats[index].timestamp!.day !=
                        chats[index - 1].timestamp!.day);

                /// [isSentByCurrentUser] message was sent by our current user
                final isSentByCurrentUser = chats[index].senderId == user.id;

                final isTextMessage =
                    chats[index].messageType == textMessageFlag ||
                        chats[index].messageType == null;

                final isAudioMessage =
                    chats[index].messageType == audioMessageFlag &&
                        chats[index].url != null;

                if (isNewDay) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ChatTimePill(
                          time: chats[index].timestamp!.formatDescriptive,
                        ),
                      ),

                      // append sender voice or text bubble
                      if (isSentByCurrentUser)
                        ..._showSenderTextOrAudioMessage(
                          isTextMessage,
                          chats,
                          index,
                        )

                      // append recipient voice or text bubble
                      else
                        ..._showRecipientTextOrAudioMessage(
                          isTextMessage,
                          chats,
                          index,
                        ),
                    ],
                  );
                }

                // show sender voice or text bubble
                if (isSentByCurrentUser) {
                  if (isTextMessage) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SenderChatBubble(
                        message: chats[index],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: SenderVoiceBubble(
                      message: chats[index],
                    ),
                  );
                }

                // show recipient voice or text bubble
                else {
                  if (isTextMessage) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RecipientChatBubble(
                        message: chats[index],
                      ),
                    );
                  }
                  // show recipient voice audio only if file is audio and url
                  // exits
                  else if (isAudioMessage) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RecipientVoiceBubble(
                        message: chats[index] as Message,
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _showRecipientTextOrAudioMessage(
    bool isText,
    List<BaseMessage> chats,
    int index,
  ) {
    return [
      if (isText) ...[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: RecipientChatBubble(
            message: chats[index],
          ),
        ),
      ] else ...[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: RecipientVoiceBubble(
            message: chats[index] as Message,
          ),
        ),
      ],
    ];
  }

  List<Widget> _showSenderTextOrAudioMessage(
    bool isText,
    List<BaseMessage> chats,
    int index,
  ) {
    return [
      if (isText) ...[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SenderChatBubble(
            message: chats[index],
          ),
        ),
      ] else ...[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SenderVoiceBubble(
            message: chats[index],
          ),
        ),
      ],
    ];
  }
}
