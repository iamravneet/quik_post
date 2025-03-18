part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String username;
  Authenticated(this.user, this.username);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

class AuthLoading extends AuthState {}