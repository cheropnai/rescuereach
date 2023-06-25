import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescuereach/components/my_button_reset.dart';
import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';
import 'package:rescuereach/services/auth/bloc/auth_state.dart';
import 'package:rescuereach/utilities/dialogs/error_dialog.dart';
import 'package:rescuereach/utilities/dialogs/password_reset_email_sent_dialog.dart';

import '../components/my_button.dart';
import '../utils/config.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context,
                'We could not process your request. Please make sure you have created an account, if not, go back and sign up');
          }
        }
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 191, 166, 233),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      const Image(
                        image: AssetImage(Config.resreach_icon),
                        height: 150,
                        width: 150,
                        // fit: BoxFit.cover,
                      ),
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        ' A password reset link will be sent to your email',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade700)),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.grey),
                          // icon: Icon(Icons.email),
                          // labelText: 'Email',

                          // helperText: 'A valid email e.g. joe.doe@gmail.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          children: [
                            MyButtonReset(
                              onTap: () {
                                final email = _controller.text;
                                context.read<AuthBloc>().add(
                                      AuthEventForgotPassword(email: email),
                                    );
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                        const AuthEventLogOut(),
                                      );
                                },
                                child: const Text('back to Login')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
