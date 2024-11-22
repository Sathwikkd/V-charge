part of 'recharge_bloc.dart';

@immutable
sealed class RechargeState {}

final class RechargeInitial extends RechargeState {}

final class FetchMachineBalanceFailureState extends RechargeState{
  final String message;
  FetchMachineBalanceFailureState({required this.message});
}

final class FetchMachineBalanceSuccessState extends RechargeState{
  final String mbalance;
  FetchMachineBalanceSuccessState({required this.mbalance});
}

final class FetchMachineBalanceLoadingState extends RechargeState{}

final class RechargeCardSuccessState extends RechargeState{
  final String message;
  RechargeCardSuccessState({required this.message});
}

final class RechargeCardErrorState extends RechargeState{
  final String message;
  RechargeCardErrorState({required this.message});
}

final class RechargeCardLoadingState extends RechargeState{}
