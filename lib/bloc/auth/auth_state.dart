part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpWithGoogleLoading extends AuthState {}

class SignUpWithAppleLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  final bool isNewUser;

  SignUpSuccess({required this.isNewUser});
}

class SignUpFailed extends AuthState {
  final AlertException exception;

  SignUpFailed({required this.exception});
}

class SignInLoading extends AuthState {}

class SignInWithGoogleLoading extends AuthState {}

class SignInWithAppleLoading extends AuthState {}

class SignInSuccess extends AuthState {
  final bool isNewUser;

  SignInSuccess({required this.isNewUser});
}

class SignInFailed extends AuthState {
  final AlertException exception;

  SignInFailed({required this.exception});
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {}

class ForgotPasswordFailed extends AuthState {
  final AlertException exception;

  ForgotPasswordFailed({required this.exception});
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailed extends AuthState {
  final AlertException exception;
  SignOutFailed({required this.exception});
}

class RequiresRecentLogin extends AuthState {
  final AlertException exception;
  RequiresRecentLogin({required this.exception});
}

class DeleteLoading extends AuthState {}

class DeleteSuccess extends AuthState {}

class DeleteFailed extends AuthState {
  final AlertException exception;

  DeleteFailed({required this.exception});
}
