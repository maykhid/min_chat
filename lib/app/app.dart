import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/ui/cubit/authentication_cubit.dart';
import 'package:min_chat/core/navigation/app_navigation_config.dart';

class MinChat extends StatelessWidget {
  const MinChat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider<AuthenticationCubit>(
      create: (context) => AuthenticationCubit(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodySmall: GoogleFonts.oswald(textStyle: textTheme.bodySmall),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
            useMaterial3: false,
          ),
          routerConfig: AppRouterConfig.goRouter,
      ),
    );
  }
}
