import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/auth_screen.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/group_chat_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/messages_screen.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/start_groupchat_screen.dart';
import 'package:min_chat/app/features/user/ui/user_screen.dart';

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
        final conversation = state.extra! as Conversation;
        return Chats(
          conversation: conversation,
        );
      },
    ),

    GoRoute(
      path: GroupChatScreen.name,
      name: 'groupChats',
      builder: (context, state) {
        final groupConversation = state.extra! as GroupConversation;
        return GroupChatScreen(
          groupConversation: groupConversation,
        );
      },
    ),

    GoRoute(
      path: UserScreen.name,
      name: 'userOptions',
      builder: (context, state) => const UserScreen(),
    ),

    GoRoute(
      path: StartGroupchatScreen.name,
      name: 'startGroupchat',
      builder: (context, state) => const StartGroupchatScreen(),
    ),
  ];
}
