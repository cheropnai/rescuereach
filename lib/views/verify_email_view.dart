import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescuereach/components/my_button_verifyemail.dart';
//import 'package:rescuereach/constants/routes.dart';
import 'package:rescuereach/services/auth/auth_provider.dart';
import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/generic_dialog.dart';
import '../utils/config.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateNeedsVerification) {
            if (state.notVerified) {
              await showGenericDialog(
                context: context,
                title: 'Not Verified',
                content:
                'This email has not been verified. If not received, please resend the verification email and try again',
                optionsBuilder: () => {'OK': null},
              );
            }
            if (state.exception != null) {
              // ignore: use_build_context_synchronously
              await showErrorDialog(context,
                  'We could not process your request. Please try again later');
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 191, 166, 233),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(Config.resreach_icon),
                  height: 150,
                  width: 150,
                  // fit: BoxFit.cover,
                ),
                const Text(
                  'Verify email',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: const Text(
                      "An email verification link has been sent to your email, tap to verify"),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: const Text(
                      "if you haven't received a verification email yet ,tap the button below"),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButtonVerifyEmail(
                  onTap: () async {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventCheckVerification(),
                    );
                  },
                  child: const Text('Proceed to HomePage'),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('back to login'),
                ),
              ],
            ),
          ),
        ));
  }
}