part of 'auth_bloc.dart';

class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {}

class AuthStateSigned extends AuthState {
  AuthStateSigned({required this.user});
  String user;
}
