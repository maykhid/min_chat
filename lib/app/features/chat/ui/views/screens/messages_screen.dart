import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/messages_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/start_conversation_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';
import 'package:min_chat/app/shared/ui/app_dialog.dart';
import 'package:min_chat/app/shared/ui/fading_widget.dart';
import 'package:min_chat/core/utils/data_response.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  static const String name = '/messages';

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthenticationCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const FaIcon(FontAwesomeIcons.penToSquare),
        onPressed: () => _showStartConversationModal(context),
      ),
      body: BlocProvider<MessagesCubit>(
        create: (context) =>
            MessagesCubit()..initConversationListener(userId: cubit.user.id),
        child: const MessagesScreenView(),
      ),
    );
  }
}

class MessagesScreenView extends StatelessWidget {
  const MessagesScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Text(
                  'Messages',
                  style: GoogleFonts.varelaRound(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                CupertinoSearchTextField(
                  placeholder: 'Search',
                  backgroundColor: Colors.grey.shade300,
                  // borderRadius: BorderRadius.circular(10),
                ),
                const Gap(20),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MessagesCubit, MessagesState>(
              builder: (context, state) {
                final hasData = state.conversations.isNotEmpty;
                // final hasData = [].isNotEmpty;

                if (!hasData) {
                  return const _AwaitingOrder();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.conversations.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const MessagesListItem();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AwaitingOrder extends StatelessWidget {
  const _AwaitingOrder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadingWidget(
        child: Text(
          'Awaiting your order...',
          style: GoogleFonts.varelaRound(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

class MessagesListItem extends StatelessWidget {
  const MessagesListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(width: 0.3, color: Colors.grey);
    return InkWell(
      onTap: () => context.push(Chats.name),
      child: Container(
        height: 72,
        width: context.width,
        padding: const EdgeInsets.only(
          left: 9,
          right: 9,
        ),
        decoration: const BoxDecoration(
          border: Border(top: border, bottom: border),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: CircleAvatar()),
            SizedBox(
              width: 9,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sandra Achus',
                  // style: AppTextStyles.normalTextStyleDarkGrey2,
                ),
                Text(
                  'Hello sir, how are you?',
                  // style: AppTextStyles.smallTextStyleGrey,
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '16:03',
                // style: AppTextStyles.smallTextStyleGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showStartConversationModal(BuildContext context) {
  final user = context.read<AuthenticationCubit>().user;
  AppDialog.showAppDialog(
    context,
    BlocProvider<StartConversationCubit>(
      create: (context) => StartConversationCubit(),
      child: SizedBox(
        height: 140,
        width: context.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Enter user MID or Email to start chatting',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              CupertinoSearchTextField(
                borderRadius: BorderRadius.circular(8),
                prefixIcon: const SizedBox.shrink(),
                placeholder: 'MID or Email',
                backgroundColor: Colors.grey.shade100,
                // borderRadius: BorderRadius.circular(10),
              ),
              BlocConsumer<StartConversationCubit, StartConversationState>(
                listener: (context, state) {
                  if (state.status.isSuccess) {
                    print('created conversation');
                  } else if (state.status.isError) {
                  } else {}
                },
                builder: (context, state) {
                  final cubit = context.read<StartConversationCubit>();

                  return AppIconButton(
                    text: 'OK',
                    icon: const SizedBox.shrink(),
                    height: 15,
                    width: 120,
                    borderRadius: 8,
                    color: Colors.black,
                    onPressed: () {
                      cubit.startConversation(
                        recipientMIdOrEmail: 'macliquemaykhid@gmail.com',
                        senderMid: user.mID!,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
