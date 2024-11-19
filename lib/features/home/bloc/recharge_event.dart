part of 'recharge_bloc.dart';

@immutable
sealed class RechargeEvent {}


class FetchCardBalance extends RechargeEvent{
  final BluetoothConnection connection;
  FetchCardBalance({required this.connection});
}
