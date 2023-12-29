import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/auth/ui/cubit/sign_in_cubit.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/messages_screen.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';
import 'package:min_chat/app/shared/ui/app_dialog.dart';
import 'package:min_chat/core/utils/data_response.dart';
import 'package:toastification/toastification.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignInCubit>(
        create: (context) => SignInCubit(),
        child: const AuthView(),
      ),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final signInCubit = context.read<SignInCubit>();
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status.isError) {
          context.pop(); // remove load dialog
          toastification.show(
            context: context,
            title: state.message!,
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
          );
        } else if (state.status.isSuccess) {
          context
            ..pop() // remove load dialog
            ..pushReplacement(MessagesScreen.name);
        } else {
          AppDialog.showAppDialog(
            context,
            const SizedBox(
              height: 100,
              width: 70,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MinChat',
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              // TODO(maykind): use FontAwesomeIcons.waze as icon
              const FaIcon(
                FontAwesomeIcons.waze,
                size: 40,
                color: Colors.black,
              ),
            ],
          ),
          const Gap(80),
          const Text(
            'Continue with',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          const Gap(20),
          AppIconButton(
            text: 'Google',
            icon: const FaIcon(FontAwesomeIcons.google, size: 24),
            onPressed: signInCubit.signInWithGoogle,
          ),
          const SizedBox(height: 10),
          // const Text(
          //   'or',
          //   style: TextStyle(
          //     color: Colors.pinkAccent,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // AppIconButton(
          //   text: 'GitHub',
          //   icon: const FaIcon(FontAwesomeIcons.github, size: 24),
          //   onPressed: signInCubit.signInWithGithub,
          //   color: Colors.black,
          // ),
        ],
      ),
    );
  }
}
