import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';

class UserOptionsScreen extends StatelessWidget {
  const UserOptionsScreen({super.key});

  static const String name = '/userOptions';

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          'Options',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          const Gap(12),
          CircleAvatar(
            backgroundImage: NetworkImage(user.state.user.imageUrl!),
            radius: 30,
          ),
          const Gap(8),
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              if (state.status == AuthenticationStatus.unauthenticated) {
                context.go('/');
              }
            },
            child: ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              leading: const Icon(Icons.exit_to_app),
              onTap: user.signOut,
            ),
          ),
        ],
      ),
    );
  }
}
