part of 'auth_bloc.dart';

sealed class AuthEvent {}

class SignUp extends AuthEvent {
  final String email;
  final String password;

  SignUp({required this.email, required this.password});
}

class SignIn extends AuthEvent {
  final String email;
  final String password;

  SignIn({required this.email, required this.password});
}

class ForgotPassword extends AuthEvent {
  final String email;

  ForgotPassword({required this.email});
}

class SignOut extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignInWithApple extends AuthEvent {}

class SignUpWithGoogle extends AuthEvent {}

class SignUpWithApple extends AuthEvent {}

class Delete extends AuthEvent {}
