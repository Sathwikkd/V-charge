part of 'connection_bloc.dart';

@immutable
sealed class ConnectionsState {}

final class ConnectionInitial extends ConnectionsState {}


final class ConnectToMachineSuccessState extends ConnectionsState{
  final String machineId;
  final String amount;
  final BluetoothConnection connection;
  ConnectToMachineSuccessState({required this.machineId , required this.amount , required this.connection});
}

final class ConnectToMachineFailureState extends ConnectionsState{
  final String message;
  ConnectToMachineFailureState({required this.message});
}

final class ConnectToMachineLoadingState extends ConnectionsState{
  
}

