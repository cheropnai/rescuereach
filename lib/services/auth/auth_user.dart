import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String phoneNumber; // New property for phone number

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.phoneNumber,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        phoneNumber: user.phoneNumber!, // Initialize phone number from user object
      );
}
