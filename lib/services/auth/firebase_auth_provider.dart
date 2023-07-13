//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rescuereach/firebase_options.dart';
import 'package:rescuereach/services/auth/auth_user.dart';
import 'package:rescuereach/services/auth/auth_exceptions.dart';
import 'package:rescuereach/services/auth/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescuereach/services/firestore/UserCollection.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      //UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create user collection in Firestore
      await createUserCollectionOnRegister();
      final user = currentUser;

      print(email);
      print('creating firebase user');
      // _firestore
      //     .collection('users')
      //     .doc(userCredential.user!.uid)
      //     .set({'uid': userCredential.user!.uid, 'email': email});
      // print('creating user collection in firestore');

      if (user != null) {
        print(user);
        return user;
      } else {
        throw UserNotLoggedInException;
      }
      //creating a new documnet for the the new user that has just been created.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserCollectionOnLogin();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> get reloadUser async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> loginWithGoogle() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      print('sent account select request');
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // Retrieve the authentication details
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      print('googleAuth detaills llllllllllllllllllldddddddddddddddddddddddd');
      print(googleAuth);
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Google Sign up is now sending credentials to Firebase');
      await firebaseAuth.signInWithCredential(credential);

      final user = currentUser;
      print(user);
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      print('did not sing innnnnnnnnnnnn');
      print(e);
      throw const LogInWithGoogleFailure();
    }
  }

  // Future<AuthUser> loginWithPhone() {
  //   // TODO: implement loginWithPhone
  //   throw UnimplementedError();
  // }
  Future<void> createUserCollectionOnRegister() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userEmail = currentUser.email;
      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .set({'uid': userId, 'email': userEmail});
      print('creating user collection in Firestore');
    } else {
      print('No current user logged in.');
    }
  }

  Future<void> createUserCollectionOnLogin() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userEmail = currentUser.email;
      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .set({'uid': userId, 'email': userEmail}, SetOptions(merge: true));
      print('creating user collection in Firestore');
    } else {
      print('No current user logged in.');
    }
  }

  @override
  Future<void> createUserCollection(
      {required String phoneNumber, required String roleName}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userEmail = currentUser.email;
      await firestore.collection('users').doc(currentUser.uid).set({
        'uid': userId,
        'email': userEmail,
        'phone': phoneNumber,
        'role': roleName
      });
      print('creating user collection in Firestore');
    } else {
      print('No current user logged in.');
    }
  }
}