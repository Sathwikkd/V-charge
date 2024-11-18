part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;
  AuthLoginEvent({required this.username, required this.password});
} 

class AuthLogoutEvent extends AuthEvent{}
