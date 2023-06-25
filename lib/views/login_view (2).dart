import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescuereach/components/my_button.dart';
import 'package:rescuereach/components/my_textfield.dart';
import 'package:rescuereach/services/auth/auth_exceptions.dart';
import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';
import 'package:rescuereach/services/auth/bloc/auth_state.dart';
import 'package:rescuereach/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

import '../components/square_tile.dart';
import '../utils/config.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _key = GlobalKey<FormState>();
  late MyFormState _state;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(email: Email.dirty(_emailController.text));
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _state = _state.copyWith(
        password: Password.dirty(_passwordController.text),
      );
    });
  }

  Future<void> _onSubmit() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _state = _state.copyWith(status: FormzSubmissionStatus.inProgress);
    });

    try {
      await _submitForm();
      _state = _state.copyWith(status: FormzSubmissionStatus.success);
    } catch (_) {
      _state = _state.copyWith(status: FormzSubmissionStatus.failure);
    }

    if (!mounted) return;

    setState(() {});

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();

    const successSnackBar = SnackBar(
      content: Text('Submitted !'),
    );
    const failureSnackBar = SnackBar(
      content: Text('An error has occurred'),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _state.status.isSuccess ? successSnackBar : failureSnackBar,
      );

    if (_state.status.isSuccess) {
      _resetForm();
    }
  }

  Future<void> _submitForm() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    context.read<AuthBloc>().add(
          AuthEventLogIn(
            email,
            password,
          ),
        );
  }

  void _resetForm() {
    _key.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();
    setState(() => _state = MyFormState());
  }

  @override
  void initState() {
    _state = MyFormState();
    _emailController = TextEditingController(text: _state.email.value)
      ..addListener(_onEmailChanged);
    _passwordController = TextEditingController(text: _state.password.value)
      ..addListener(_onPasswordChanged);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is WrongPasswordAuthException ||
              state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Incorrect credentials, try again');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 191, 166, 233),
        //appBar: AppBar(title: const Text('Login')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  //logo
                  const Image(
                    image: AssetImage(Config.resreach_icon),
                    height: 150,
                    width: 150,
                    // fit: BoxFit.cover,
                  ),
                  // const Icon(
                  //   Icons.local_car_wash,
                  //   size: 100,
                  // ),

                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _key,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Colors.grey),
                            // icon: Icon(Icons.email),
                            // labelText: 'Email',

                            helperText:
                                'A valid email e.g. jane.dickens@gmail.com',
                          ),
                          obscureText: false,
                          validator: (_) => _state.email.displayError?.text(),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'password',
                            hintStyle: TextStyle(color: Colors.grey),
                            helperText:
                                'At least 8 characters including one letter and number',
                            helperMaxLines: 2,
                            errorMaxLines: 2,
                          ),
                          validator: (_) =>
                              _state.password.displayError?.text(),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Text(
                            //   'Forgot Password?',
                            //   style: TextStyle(color: Colors.grey.shade600),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                      const AuthEventForgotPassword(),
                                    );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_state.status.isInProgress)
                        const CircularProgressIndicator()
                      else
                        MyButton(
                          onTap: _onSubmit,
                        ),

                      const SizedBox(height: 24),
                      //or continue with.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                'or continue with',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // if (_state.status.isInProgress)
                      //   const CircularProgressIndicator()

                      // ElevatedButton(
                      //   onPressed: _onSubmit,
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(60),
                      //     ),
                      //     // backgroundColor: theme.colorScheme.secondary,
                      //   ),
                      //   child: const Text('Sign in'),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            key:
                                const Key('loginForm_googleLogin_raisedButton'),
                            onTap: () => context
                                .read<AuthBloc>()
                                .add(const AuthEventGoogleLogin()),
                            child: const SquareTile(
                              imagePath: Config.app_icon,
                              child: Text(''),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            key: const Key(''),
                            onTap: () => context
                                .read<AuthBloc>()
                                .add(const AuthEventGoogleLogin()),
                            child: const SquareTile(
                              imagePath: Config.mac_icon,
                              child: Text(''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventShouldRegister(),
                                  );
                            },
                            child: const Text(
                              "Not a member? Register now",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )

                      // ElevatedButton.icon(
                      //   key: const Key('loginForm_googleLogin_raisedButton'),
                      //   label: const Text(
                      //     'SIGN IN WITH GOOGLE',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     // backgroundColor: theme.colorScheme.secondary,
                      //   ),
                      //   icon: const Icon(
                      //     FontAwesomeIcons.google,
                      //     size: 20,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () => context
                      //       .read<AuthBloc>()
                      //       .add(const AuthEventGoogleLogin()),
                      // ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyFormState with FormzMixin {
  MyFormState({
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
  }) : email = email ?? Email.pure();

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;

  MyFormState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return MyFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];
}

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError>
    with FormzInputErrorCacheMixin {
  Email.pure([super.value = '']) : super.pure();

  Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();

  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegex.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}

extension on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.invalid:
        return '''Password must be at least 8 characters and contain at least one letter and number''';
    }
  }
}
