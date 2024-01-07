import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/ui/auth_screen.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/messages_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/start_groupchat_screen.dart';
import 'package:min_chat/app/features/user/ui/user_options_screen.dart';

class AppRoutes {
  static List<GoRoute> routes = [
    // List of go routes
    GoRoute(
      path: '/',
      name: 'auth',
      builder: (context, state) => const AuthScreen(),
      redirect: (context, state) {
        final authState = context.read<AuthenticationCubit>().state;
        if (authState.status == AuthenticationStatus.authenticated) {
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
        final authState = context.read<AuthenticationCubit>().state;

        if (authState.status == AuthenticationStatus.unauthenticated) {
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

    GoRoute(
      path: UserOptionsScreen.name,
      name: 'userOptions',
      builder: (context, state) => const UserOptionsScreen(),
    ),

    GoRoute(
      path: StartGroupchatScreen.name,
      name: 'startGroupchat',
      builder: (context, state) => const StartGroupchatScreen(),
    ),
  ];
}
