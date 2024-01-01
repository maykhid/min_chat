import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/auth_screen.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/messages_screen.dart';

class AppRoutes {
  static List<GoRoute> routes = [
    // List of go routes
    GoRoute(
      path: '/',
      name: 'auth',
      builder: (context, state) {
        return const AuthScreen();
      },
      redirect: (context, state) {
        final authState = context.read<AuthenticationCubit>();
        if (authState.user.isNotEmpty) {
          return '/messages';
        }
        return null;
      },
    ),

    GoRoute(
      path: MessagesScreen.name,
      name: 'messages',
      builder: (context, state) => const MessagesScreen(),
      redirect: (context, state) {
        final authState = context.read<AuthenticationCubit>();
        if (authState.user.isEmpty) {
          return '/';
        }
        return null;
      },
    ),

    GoRoute(
      path: Chats.name,
      name: 'chats',
      builder: (context, state) {
        final minChatUser = state.extra! as MinChatUser;
        return Chats(
          recipientUser: minChatUser,
        );
      },
    ),
  ];
}
