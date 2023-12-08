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

class ChatsView extends StatelessWidget {
  const ChatsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final chats = context.read<ChatCubit>().state.chats;
    final currentUser = context.read<AuthenticationCubit>().user;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chats = state.chats;
        return Padding(
          padding: const EdgeInsets.symmetric( horizontal: 16),
          child: SizedBox.expand(
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                if (chats[index].senderId == currentUser.id) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: SenderChatBubble(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: RecipientChatBubble(),
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
    super.key,
  });

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
                color: Colors.black87,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(8),
                  bottomEnd: Radius.circular(8),
                  bottomStart: Radius.circular(8),
                ),
              ),
              child: const SizedBox(
                // width: 200,
                child: Text(
                  '''Yes ma, I would. ''',
                  style: TextStyle(color: Colors.white),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '16:03',
                // style: AppTextStyles.smallTextStylePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  const SenderChatBubble({
    super.key,
  });

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
              color: Colors.black12,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: const SizedBox(
              // width: 200,
              child: Text(
                '''Hello Ayo, I was expecting you around to fix the broken pipe. I was expecting you around to fix the broken pipe.''',
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '16:03',
              // style: AppTextStyles.smallTextStylePrimary,
            ),
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
    final keyboardHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _bottomOffset = keyboardHeight * 0.35;
      // prevent textfield from reaching the bottom on keyboard hide
      if (keyboardHeight < 50) {
        _bottomOffset = 50;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final sendMessageCubit = context.read<SendMessageCubit>();
    final currentUser = context.read<AuthenticationCubit>().user;

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
                      onTap: () => sendMessageCubit.sendMessage(
                        message: Message(
                          senderId: currentUser.id,
                          recipientId: _recipientId,
                          message: controller.text,
                        ),
                      ),
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
