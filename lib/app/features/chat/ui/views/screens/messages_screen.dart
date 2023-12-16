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
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/cubits/messages_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/start_conversation_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';
import 'package:min_chat/app/shared/ui/app_dialog.dart';
import 'package:min_chat/app/shared/ui/app_text_field.dart';
import 'package:min_chat/app/shared/ui/fading_widget.dart';
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
    required this.conversation,
    super.key,
  });

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationCubit>().user;
    final conversationUser = conversation.participants
        .extrapolateParticipantByCurrentUserId(currentUser.id);

    const border = BorderSide(width: 0.3, color: Colors.grey);

    final hasLastMessage = conversation.lastMessage != null;

    String senderName() {
      if (hasLastMessage &&
          conversation.lastMessage!.isFromCurrentUser(currentUser.id)) {
        return 'You';
      }
      return conversationUser.name!.firstword;
    }

    return InkWell(
      onTap: () => context.push(Chats.name, extra: conversationUser),
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
                        ? '''${senderName()}: ${conversation.lastMessage!.message}'''
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
                conversation.lastUpdatedAt.format,
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

void _showStartConversationModal(BuildContext context) {
  final user = context.read<AuthenticationCubit>().user;

  final validator = ValidationBuilder()
      .or(
        (builder) => builder.mId().maxLength(9).build(),
        (builder) => builder.email().maxLength(31).build(),
        reverse: true,
      )
      .build();

  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final focusNode = FocusNode();

  late String midOrEmail;

  void handleStartConversation(StartConversationCubit cubit) {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      focusNode.unfocus();
      cubit.startConversation(
        recipientMIdOrEmail: midOrEmail,
        senderMid: user.mID!,
      );
    }
  }

  AppDialog.showAppDialog(
    context,
    BlocProvider<StartConversationCubit>(
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
    ),
  );
}
