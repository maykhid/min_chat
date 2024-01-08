import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/ui/cubits/start_groupchat_cubit/start_groupchat_cubit.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';

class StartGroupchatScreen extends StatefulWidget {
  const StartGroupchatScreen({super.key});

  static const String name = '/startGroupchat';

  @override
  State<StartGroupchatScreen> createState() => _StartGroupchatScreenState();
}

class _StartGroupchatScreenState extends State<StartGroupchatScreen> {
  bool _isCreateGroupButtonEnabled = false;
  final _selectedUsers = <MinChatUser>[];

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
              print(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is StartGroupchatInitial) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              final users = (state as GotConversersState).conversers;

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
                        value: _selectedUsers.contains(user),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              _selectedUsers.add(user);
                            } else {
                              _selectedUsers.remove(user);
                            }
                            _updateCreateGroupButtonState();
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
                        // width: 130,
                        onPressed: _isCreateGroupButtonEnabled
                            ? () {
                                // Implement group creation logic using selected contacts
                              }
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

  void _updateCreateGroupButtonState() {
    setState(() {
      _isCreateGroupButtonEnabled = _selectedUsers.isNotEmpty;
    });
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
