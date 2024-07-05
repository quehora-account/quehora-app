import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/globals.dart';
import 'package:hoora/repository/auth_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final CrashRepository crashRepository;

  AuthBloc({required this.authRepository, required this.crashRepository}) : super(AuthInitial()) {
    on<SignUp>(signUp);
    on<SignIn>(signIn);
    on<ForgotPassword>(forgotPassword);
    on<SignInWithApple>(signInWithApple);
    on<SignInWithGoogle>(signInWithGoogle);
    on<SignUpWithApple>(signUpWithApple);
    on<SignUpWithGoogle>(signUpWithGoogle);
    on<SignOut>(signOut);
    on<Delete>(delete);
  }

  void forgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(ForgotPasswordLoading());
      await authRepository.forgotPassword(event.email);
      emit(ForgotPasswordSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      if (exception is! FirebaseAuthException) {
        crashRepository.report(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ForgotPasswordFailed(exception: alertException));
    }
  }

  void signIn(SignIn event, Emitter<AuthState> emit) async {
    try {
      emit(SignInLoading());
      await authRepository.signIn(event.email, event.password);
      emit(SignInSuccess(isNewUser: false));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      if (exception is! FirebaseAuthException) {
        crashRepository.report(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signInWithApple(SignInWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithAppleLoading());
      bool isNewUser = await authRepository.signInWithApple();
      emit(SignInSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithGoogleLoading());
      bool isNewUser = await authRepository.signInWithGoogle();
      emit(SignInSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signUpWithApple(SignUpWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithAppleLoading());
      bool isNewUser = await authRepository.signInWithApple();
      emit(SignUpSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }

  void signUpWithGoogle(SignUpWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithGoogleLoading());
      bool isNewUser = await authRepository.signInWithGoogle();
      emit(SignUpSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }

  void signUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpLoading());
      await authRepository.signUp(event.email, event.password);
      emit(SignUpSuccess(isNewUser: true));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      if (exception is! FirebaseAuthException) {
        crashRepository.report(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }

  void signOut(SignOut event, Emitter<AuthState> emit) async {
    try {
      emit(SignOutLoading());
      await authRepository.signOut();
      emit(SignOutSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);

      emit(SignOutFailed(exception: alertException));
    }
  }

  void delete(Delete event, Emitter<AuthState> emit) async {
    try {
      emit(DeleteLoading());
      await authRepository.delete();

      /// Reset first launch
      (await SharedPreferences.getInstance())
          .setString(AppConstants.kSSKeyFirstLaunch, "");

      emit(DeleteSuccess());
    } catch (exception) {
      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);

      if (exception is FirebaseAuthException && exception.code == "requires-recent-login") {
        emit(RequiresRecentLogin(exception: alertException));
      } else {
        emit(DeleteFailed(exception: alertException));
      }
    }
  }
}
