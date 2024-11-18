import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectToMachineEvent>(_connectToMachine);
  }
  Future<void> _connectToMachine(ConnectToMachineEvent event,Emitter<ConnectionState> emit) async{
    emit(ConnectToMachineLoadingState());

  
  }
}
