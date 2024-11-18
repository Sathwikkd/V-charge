part of 'connection_bloc.dart';

@immutable
sealed class ConnectionState {}

final class ConnectionInitial extends ConnectionState {}


final class ConnectToMachineSuccessState extends ConnectionState{
  final String machineId;
  ConnectToMachineSuccessState({required this.machineId});
}

final class ConnectToMachineFailureState extends ConnectionState{
  final String message;
  ConnectToMachineFailureState({required this.message});
}

final class ConnectToMachineLoadingState extends ConnectionState{
  
}

