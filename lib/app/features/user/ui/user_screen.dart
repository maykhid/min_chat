import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  static const String name = '/userOptions';

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
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
          Hero(
            tag: 'circleavatar',
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.state.user.imageUrl!),
              radius: 35,
            ),
          ),
          const Gap(8),
          Text(
            '${user.state.user.name}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(5),
          Text(
            user.state.user.email!,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'mID: ${user.state.user.mID}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(5),
              InkWell(
                child: const FaIcon(
                  FontAwesomeIcons.copy,
                  size: 16,
                  color: Colors.blueGrey,
                ),
                onTap: () => FlutterClipboard.copy(user.state.user.mID!).then(
                  (_) => Fluttertoast.showToast(
                    msg: 'mID copied successfully!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity:
                        ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              ),
            ],
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
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
