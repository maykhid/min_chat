import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/chat_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/send_message_cubit.dart';
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
            child: const ChatsView(),
          ),
        ),

        // messageing text box
        BlocProvider<SendMessageCubit>(
          create: (context) => SendMessageCubit(),
          child: _MessagingTextBox(
            recipientId: _recipientUser.id,
          ),
        ),
      ],
    );
  }
}

class ChatsView extends StatefulWidget {
  const ChatsView({
    super.key,
  });

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> with WidgetsBindingObserver {
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
                if (chats[index].senderId == currentUser.id) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SenderChatBubble(
                      message: chats[index],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 2),
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

class RecipientChatBubble extends StatelessWidget {
  const RecipientChatBubble({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(8),
                  bottomEnd: Radius.circular(8),
                  bottomStart: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(color: Colors.black),
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(message.timestamp!)
                        .formatToTime,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  const SenderChatBubble({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // height: 56,
            // width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: const BoxDecoration(
              // color: Colors.black12,
              color: Colors.black87,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.message,
                  style: const TextStyle(color: Colors.white),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(message.timestamp!)
                      .formatToTime,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}

class _MessagingTextBox extends StatefulWidget {
  const _MessagingTextBox({required this.recipientId});

  final String recipientId;

  @override
  State<_MessagingTextBox> createState() => _MessagingTextBoxState();
}

class _MessagingTextBoxState extends State<_MessagingTextBox>
    with WidgetsBindingObserver {
  double _bottomOffset = 50;
  late String _recipientId;

  final controller = TextEditingController();

  @override
  void initState() {
    _recipientId = widget.recipientId;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    moveTextBoxPositionOnKeyboardShow();
    super.didChangeMetrics();
  }

  void moveTextBoxPositionOnKeyboardShow() {
    final keyboardHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      // prevent textfield from reaching the bottom on keyboard hide
      if (keyboardHeight < 50) {
        _bottomOffset = 50;
      } else {
        _bottomOffset = context.height * 0.42;
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
                    InkWell(
                      onTap: sendMessage,
                      child: const FaIcon(FontAwesomeIcons.paperPlane),
                    ),
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
