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
      builder: (context, state) {
        final authState = context.read<AuthenticationCubit>();
        if (authState.user.isNotEmpty) {
          return const MessagesScreen();
        }

        return const AuthScreen();
      },
    ),

    GoRoute(
      path: MessagesScreen.name,
      builder: (context, state) => const MessagesScreen(),
    ),

    GoRoute(
      path: Chats.name,
      builder: (context, state) {
        final minChatUser = state.extra! as MinChatUser;
        return Chats(
          recipientUser: minChatUser,
        );
      },
    ),
  ];
}
