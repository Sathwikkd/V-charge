part of 'auth_bloc.dart';

@immutable 
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoginSuccessState extends AuthState{}

final class AuthLoginFailureState extends AuthState{

  final String message;
  AuthLoginFailureState({required this.message});
  
}

final class AuthLoginLoadingState extends AuthState{}
final class AuthLogoutSuccessState extends AuthState{}
final class AuthLogoutFailureState extends AuthState{
  final String message;
AuthLogoutFailureState({required this.message});
}



