import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/ui/cubits/start_groupchat_cubit/start_groupchat_cubit.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';
import 'package:min_chat/app/shared/ui/app_dialog.dart';
import 'package:min_chat/app/shared/ui/app_text_field.dart';
import 'package:min_chat/core/utils/sized_context.dart';
import 'package:toastification/toastification.dart';

class StartGroupchatScreen extends StatefulWidget {
  const StartGroupchatScreen({super.key});

  static const String name = '/startGroupchat';

  @override
  State<StartGroupchatScreen> createState() => _StartGroupchatScreenState();
}

class _StartGroupchatScreenState extends State<StartGroupchatScreen> {
  bool _isCreateGroupButtonEnabled = false;
  // final _selectedUsers = <MinChatUser>[];

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;

    return BlocProvider<StartGroupchatCubit>(
      create: (context) =>
          StartGroupchatCubit()..fetchConversers(userId: user.id),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            'Start a group chat',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        body: BlocConsumer<StartGroupchatCubit, StartGroupchatState>(
          listener: (context, state) {
            if (state is ErrorState) {
              // error message display
            } 
          },
          builder: (context, state) {
            final selectedUsers =
                context.read<StartGroupchatCubit>().selectedParticipants;
            if (state is StartGroupchatInitial) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              final users = state.conversers;

              if (users.isEmpty) {
                return const _NoConversers();
              }

              return Column(
                children: [
                  ListView.separated(
                    itemCount: users.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) => const Gap(8),
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return CheckboxListTile(
                        activeColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(width: 0.3, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // shape: const CircleBorder(side: BorderSide()),
                        title: Text(user.name!),
                        subtitle: Text(user.mID!),
                        value: selectedUsers.contains(user),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              selectedUsers.add(user);
                            } else {
                              selectedUsers.remove(user);
                            }
                            _isCreateGroupButtonEnabled =
                                selectedUsers.isNotEmpty;
                          });
                        },
                      );
                    },
                  ),
                  const Gap(80),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: AppIconButton(
                        text: 'Start Conversation',
                        color: Colors.black,
                        icon: Container(),
                        height: 40,
                        isLoading: state is CreatingGroupChatState,
                        onPressed: _isCreateGroupButtonEnabled
                            ? () => _showStartConversationModal(context)
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _NoConversers extends StatelessWidget {
  const _NoConversers();

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

class EnterGroupNameWidget extends StatefulWidget {
  const EnterGroupNameWidget({
    required this.cubit,
    super.key,
  });

  final StartGroupchatCubit cubit;

  @override
  State<EnterGroupNameWidget> createState() => _EnterGroupNameWidgetState();
}

class _EnterGroupNameWidgetState extends State<EnterGroupNameWidget> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>().state.user;
    final cubit = widget.cubit;

    late String groupName;

    GroupConversation buildConversation() {
      // group conversation data
      return GroupConversation(
        initiatedBy: user.id,
        initiatedAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
        participantsIds: cubit.selectedParticipants.map((e) => e.id).toList()
          ..add(user.id),
        groupName: groupName,
      );
    }

    void handleStartGroupchat(StartGroupchatCubit cubit) {
      final isValid = formKey.currentState!.validate();

      if (isValid) {
        formKey.currentState!.save();
        focusNode.unfocus();

        cubit.startGroupChat(
          groupConversation: buildConversation(),
        );
      }
    }

    return BlocProvider.value(
      value: cubit,
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
                  'Enter a group name',
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
                    validate: (name) {
                      if (name!.isEmpty || name.length < 3) {
                        return 'Not a valid group name';
                      }
                      return null;
                    },
                    borderRadius: 10,
                    onSaved: (value) => groupName = value!,
                  ),
                ),
                BlocConsumer<StartGroupchatCubit, StartGroupchatState>(
                  listener: (context, state) {
                    if (state is GroupChatCreatedState) {
                      // context
                      //   ..pop() // remove dialog
                      //   ..push('');
                    } else if (state is ErrorState) {
                      toastification.show(
                        context: context,
                        title: state.errorMessage!,
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
                  },
                  builder: (context, state) {
                    return AppIconButton(
                      text: 'OK',
                      icon: const SizedBox.shrink(),
                      height: 15,
                      width: 120,
                      borderRadius: 8,
                      color: Colors.black,
                      isLoading: state is CreatingGroupChatState,
                      onPressed: () => handleStartGroupchat(cubit),
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
    EnterGroupNameWidget(
      cubit: context.read<StartGroupchatCubit>(),
    ),
  );
}
