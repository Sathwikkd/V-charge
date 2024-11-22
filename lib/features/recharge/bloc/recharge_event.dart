part of 'recharge_bloc.dart';

@immutable
sealed class RechargeEvent {}

class FetchMachineBalanceEvent extends RechargeEvent{
  final String machineID;
  FetchMachineBalanceEvent({required this.machineID});
}

class RechargeCardEvent extends RechargeEvent {
  final String machineID;
  final String balance;
  final String address;
  final String amount;
  final String mbalance;
  RechargeCardEvent({
    required this.machineID,
    required this.balance,
    required this.address,
    required this.amount,
    required this.mbalance
  });
}
