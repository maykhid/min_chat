import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:min_chat/app/features/auth/ui/auth_screen.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';

class AppRoutes {
  static List<GoRoute> routes = [
    // List of go routes
    GoRoute(
      path: '/',
      builder: (context, state) {
        final authState = context.read<AuthenticationCubit>();
        if (authState.user.isNotEmpty) {
          return Container();
        }

        return const AuthScreen();
      },
    ),

    // // GoRoute(
    // //   path: OrderTimelineScreen.name,
    // //   builder: (context, state) => const OrderTimelineScreen(),
    // // ),

    // GoRoute(
    //   path: OrderDetailScreen.name,
    //   builder: (context, state) => const OrderDetailScreen(),
    // ),
  ];
}
