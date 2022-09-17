part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventSignIn extends AuthEvent {
  const AuthEventSignIn({required this.userCredentials});
  final String userCredentials;
}

class AuthEventSignOut implements AuthEvent {}
