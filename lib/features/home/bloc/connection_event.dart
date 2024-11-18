part of 'connection_bloc.dart';

@immutable
sealed class ConnectionEvent {}


class ConnectToMachineEvent extends ConnectionEvent{}
