part of 'recharge_bloc.dart';

@immutable
sealed class RechargeState {}

final class RechargeInitial extends RechargeState {}

final class FetchCardBalanceSuccessState extends RechargeState{
  final String balance;
  FetchCardBalanceSuccessState({required this.balance});
}

final class FetchCardBalanceErrorState extends RechargeState{
  final String message;
  FetchCardBalanceErrorState({required this.message});
}

final class RegisterLoadingState extends RechargeState{}
