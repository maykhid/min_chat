import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
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
import 'package:min_chat/core/utils/sized_context.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({
    required this.groupConversation,
    super.key,
  });

  static const String name = '/groupChatScreen';

  final GroupConversation groupConversation;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late GroupConversation _groupConversation;

  @override
  void initState() {
    _groupConversation = widget.groupConversation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      const CircleAvatar(
                        // backgroundImage: NetworkImage(''),
                        backgroundColor: Colors.black,
                        child: FaIcon(
                          FontAwesomeIcons.userGroup,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _groupConversation.groupName,
                          // style: AppTextStyles.normalTextStyleDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: BlocProvider<ChatCubit>(
            create: (context) => ChatCubit()
              ..initGroupMessageListener(
                id: _groupConversation.documentId!,
              ),
            child: const _GroupChatView(),
          ),
        ),

        // messageing text box
        BlocProvider<SendMessageCubit>(
          create: (context) => SendMessageCubit(),
          child: TextVoiceBoxToggler(
            conversationId: _groupConversation.documentId,
          ),
        ),
      ],
    );
  }
}

class _GroupChatView extends StatefulWidget {
  const _GroupChatView();

  @override
  State<_GroupChatView> createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<_GroupChatView>
    with WidgetsBindingObserver {
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
                        message: chats[index],
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
            message: chats[index],
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
