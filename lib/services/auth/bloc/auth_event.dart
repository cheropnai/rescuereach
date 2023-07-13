import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventGoogleLogin extends AuthEvent {
  const AuthEventGoogleLogin();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  // final String Role;
  const AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventFurtherRegistration extends AuthEvent {
  final String phoneNumber;
  final String role;
  const AuthEventFurtherRegistration(
      this.phoneNumber, this.role
      );
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventCheckVerification extends AuthEvent {
  const AuthEventCheckVerification();
}