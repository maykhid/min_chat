import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/chat_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/chat_time_pill.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_text_box.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/recipient_chat_bubble.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/sender_chat_bubble.dart';
import 'package:min_chat/core/utils/datetime_x.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class Chats extends StatefulWidget {
  const Chats({required this.recipientUser, super.key});

  static const String name = '/chats';

  final MinChatUser recipientUser;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  late MinChatUser _recipientUser;

  @override
  void initState() {
    super.initState();
    _recipientUser = widget.recipientUser;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthenticationCubit>();
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
                        backgroundImage: NetworkImage(_recipientUser.imageUrl!),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _recipientUser.name!,
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
              ..initMessageListener(
                recipientId: _recipientUser.id,
                senderId: cubit.user.id,
              ),
            child: const _ChatsView(),
          ),
        ),

        // messageing text box
        BlocProvider<SendMessageCubit>(
          create: (context) => SendMessageCubit(),
          child: MessageInputHandler(
            recipientId: _recipientUser.id,
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
    final currentUser = context.read<AuthenticationCubit>().user;

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
                final showtime = index == 0 ||
                    (chats[index].timestamp!.day !=
                        chats[index - 1].timestamp!.day);

                /// [isSentByUser] message was sent by our current user
                final isSentByUser = chats[index].senderId == currentUser.id;

                if (showtime) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ChatTimePill(
                          time: chats[index].timestamp!.formatDescriptive,
                        ),
                      ),
                      if (isSentByUser) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SenderChatBubble(
                            message: chats[index],
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: RecipientChatBubble(message: chats[index]),
                        ),
                      ],
                    ],
                  );
                }

                // show sender bubble
                if (isSentByUser) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SenderChatBubble(
                      message: chats[index],
                    ),
                  );
                }

                // show recipient bubble
                else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: RecipientChatBubble(message: chats[index]),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
