import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/messages_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/start_conversation_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/group_chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/start_groupchat_screen.dart';
import 'package:min_chat/app/features/user/ui/user_options_screen.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';
import 'package:min_chat/app/shared/ui/app_dialog.dart';
import 'package:min_chat/app/shared/ui/app_expandable_fab.dart';
import 'package:min_chat/app/shared/ui/app_text_field.dart';
import 'package:min_chat/core/utils/data_response.dart';
import 'package:min_chat/core/utils/datetime_x.dart';
import 'package:min_chat/core/utils/participants_x.dart';
import 'package:min_chat/core/utils/sized_context.dart';
import 'package:min_chat/core/utils/string_x.dart';
import 'package:min_chat/core/utils/validator_builder_x.dart';
import 'package:toastification/toastification.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  static const String name = '/messages';

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;
    return Scaffold(
      floatingActionButton: _buildExpandableFab(context),
      body: BlocProvider<MessagesCubit>(
        create: (context) =>
            MessagesCubit()..initConversationListener(userId: user.id),
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
    final user = context.read<AuthenticationCubit>().state.user;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.varelaRound(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push(
                        UserOptionsScreen.name,
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(user.imageUrl!),
                      ),
                    ),
                  ],
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
                  return const _AwaitingMessages();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.conversations.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return MessagesListItem(
                      conversation: state.conversations[index],
                    );
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

class _AwaitingMessages extends StatelessWidget {
  const _AwaitingMessages();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/min_mascot.png',
          width: 60,
          height: 60,
        ),
        Text(
          '''You have no active conversations yet.\n Click the button below to begin a conversation.''',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class MessagesListItem extends StatelessWidget {
  const MessagesListItem({
    required this.conversation,
    super.key,
  });

  final dynamic conversation;

  static const border = BorderSide(width: 0.3, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;

    if (conversation is Conversation) {
      final p2pconversation = conversation as Conversation;

      final conversationUser = p2pconversation.participants
          .extrapolateParticipantByCurrentUserId(user.id);

      final hasLastMessage = p2pconversation.lastMessage != null;

      final message =
          hasLastMessage ? p2pconversation.lastMessage! as Message : null;

      String senderName() {
        // currrent user sent last message
        if (hasLastMessage &&
            p2pconversation.lastMessage!.isMessageFromCurrentUser(user.id)) {
          return 'You';
        }
        // recipient sent last message
        return conversationUser.name!.firstword;
      }

      return InkWell(
        onTap: () => context.push(Chats.name, extra: p2pconversation),
        child: Container(
          height: 72,
          width: context.width,
          padding: const EdgeInsets.only(
            left: 9,
            right: 8,
          ),
          decoration: const BoxDecoration(
            border: Border(top: border, bottom: border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(conversationUser.imageUrl!),
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversationUser.name!,
                    // style: AppTextStyles.normalTextStyleDarkGrey2,
                  ),
                  SizedBox(
                    width: context.width * 0.65,
                    child: Text(
                      hasLastMessage
                          ? '''${senderName()}: ${message?.message}'''
                          : 'Start a conversation',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  p2pconversation.lastUpdatedAt.format,
                  style: const TextStyle(fontSize: 12),
                  // style: AppTextStyles.smallTextStyleGrey,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final groupConversation = conversation as GroupConversation;

      final hasLastMessage = groupConversation.lastMessage != null;

      final message = hasLastMessage
          ? groupConversation.lastMessage! as GroupMessage
          : null;

      final conversationUser = message?.senderInfo;

      String senderName() {
        // currrent user sent last message
        if (hasLastMessage &&
            groupConversation.lastMessage!.isMessageFromCurrentUser(user.id)) {
          return 'You';
        }
        // recipient sent last message
        return conversationUser!.name!.firstword;
      }

      return InkWell(
        onTap: () =>
            context.push(GroupChatScreen.name, extra: groupConversation),
        child: Container(
          height: 72,
          width: context.width,
          padding: const EdgeInsets.only(
            left: 9,
            right: 8,
          ),
          decoration: const BoxDecoration(
            border: Border(top: border, bottom: border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  // backgroundImage: NetworkImage(''),
                  backgroundColor: Colors.black,
                  child: FaIcon(
                    FontAwesomeIcons.userGroup,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupConversation.groupName,
                    // style: AppTextStyles.normalTextStyleDarkGrey2,
                  ),
                  SizedBox(
                    width: context.width * 0.65,
                    child: Text(
                      hasLastMessage
                          ? '''${senderName()}: ${message?.message}'''
                          : 'Be the first to start the conversation',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  groupConversation.lastUpdatedAt.format,
                  style: const TextStyle(fontSize: 12),
                  // style: AppTextStyles.smallTextStyleGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class StartConversationWidget extends StatefulWidget {
  const StartConversationWidget({
    super.key,
  });

  @override
  State<StartConversationWidget> createState() =>
      _StartConversationWidgetState();
}

class _StartConversationWidgetState extends State<StartConversationWidget> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final validator = ValidationBuilder()
      .or(
        (builder) => builder.mId().maxLength(9).build(),
        (builder) => builder.email().maxLength(31).build(),
        reverse: true,
      )
      .build();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.read<AuthenticationCubit>().state.user;

    late String midOrEmail;

    void handleStartConversation(StartConversationCubit cubit) {
      final isValid = formKey.currentState!.validate();
      if (isValid) {
        formKey.currentState!.save();
        focusNode.unfocus();
        cubit.startConversation(
          recipientMIdOrEmail: midOrEmail,
        );
      }
    }

    return BlocProvider<StartConversationCubit>(
      create: (context) => StartConversationCubit(),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: 190,
          width: context.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Enter user mID or Email to start chatting',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: AppTextField(
                    controller: controller,
                    focusNode: focusNode,
                    validate: validator,
                    borderRadius: 10,
                    onSaved: (value) => midOrEmail = value!,
                  ),
                ),
                BlocConsumer<StartConversationCubit, StartConversationState>(
                  listener: (context, state) {
                    if (state.status.isSuccess) {
                      context
                        ..pop() // remove dialog
                        ..push(Chats.name, extra: state.response);
                    } else if (state.status.isError) {
                      toastification.show(
                        context: context,
                        title: state.message!,
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
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
                      isLoading: state.status.isProcessing,
                      onPressed: () => handleStartConversation(cubit),
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
}

void _showStartConversationModal(BuildContext context) {
  AppDialog.showAppDialog(
    context,
    const StartConversationWidget(),
  );
}

AppExpandableFab _buildExpandableFab(BuildContext context) {
  return AppExpandableFab(
    distance: 70,
    children: [
      ActionButton(
        tooltip: 'Start a group chat',
        onPressed: () => context.push(StartGroupchatScreen.name),
        icon: const FaIcon(FontAwesomeIcons.userGroup),
      ),
      ActionButton(
        tooltip: 'Start a conversation',
        onPressed: () => _showStartConversationModal(context),
        icon: const FaIcon(FontAwesomeIcons.userPen),
      ),
    ],
  );
}
