import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';
import 'package:rescuereach/services/auth/bloc/auth_state.dart';
import 'package:rescuereach/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(FirebaseAuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; //user just wants to go to the forgot-password screen
      }
      //user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      Exception? exception;
      bool didSendEmail;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
    //send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    //register
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
              isLoading: false, notVerified: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventFurtherRegistration>((event, emit) async {
      final phone = event.phoneNumber;
      final role = event.role;

      try {
        await provider.createUserCollection(phoneNumber: phone, roleName: role);
        if (role == 'User') {
          emit(const AuthStateRegistrationComplete(isLoading: false));
        }else if(role == 'admin'){

        }
        else if(role == 'mentor'){

        }
         else if(role == 'organisation'){
          
        }
        else{

        }
      
      } on Exception catch (e) {
        final user = provider.currentUser;

        emit(AuthStateLoggedIn(
          user: user!,
          isLoading: false,
        ));
      }
    });
    //initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(
              isLoading: false, notVerified: false));
        } else {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      },
    );
    //google sign in
    on<AuthEventGoogleLogin>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait as you are logged in'),
        );
        try {
          final user = await provider.loginWithGoogle();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    //login
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait as you are logged in'),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateNeedsVerification(
                isLoading: false, notVerified: false));
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    //log out
    on<AuthEventCheckVerification>(
      (event, emit) async {
        emit(const AuthStateNeedsVerification(
            isLoading: true, notVerified: false));

        provider.reloadUser;
        await Future.delayed(const Duration(milliseconds: 750), () {
          try {
            final user = provider.currentUser;
            if (user != null) {
              if (!user.isEmailVerified) {
                emit(const AuthStateNeedsVerification(
                    isLoading: false, notVerified: true));
              } else {
                emit(AuthStateLoggedIn(user: user, isLoading: false));
              }
            } else {
              emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            }
          } on Exception catch (e) {
            emit(AuthStateNeedsVerification(
                isLoading: false, notVerified: false, exception: e));
          }
        });
      },
    );
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logout();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventShouldRegister>(
      (event, emit) =>
          emit(const AuthStateRegistering(isLoading: false, exception: null)),
    );
  }
}
