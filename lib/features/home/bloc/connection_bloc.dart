import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionsState> {
  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectToMachineEvent>(_connectToMachine);
  }
  Future<void> _connectToMachine(
      ConnectToMachineEvent event, Emitter<ConnectionsState> emit) async {
    emit(ConnectToMachineLoadingState());
    try {
      final BluetoothConnection connection =
          await BluetoothConnection.toAddress(event.address);
      connection.output.add(ascii.encode(jsonEncode({"st": 1})));

      StringBuffer buffer = StringBuffer();
      String machineId = "";
      final Completer<void> complete = Completer<void>();
      StreamSubscription<Uint8List>? subscription;
      subscription = connection.input!.listen((Uint8List data) async {
        buffer.write(utf8.decode(data));
        if (buffer.toString().endsWith("}")) {
          try {
            var res = jsonDecode(buffer.toString());
            machineId = res["mid"];
            complete.complete();
            await subscription?.cancel();
          } catch (e) {
            print("Error decoding JSON: $e");
          }
        }
      }, onDone: () {
        print("Stream closed.");
      }, onError: (error) {
        print("Stream error: $error");
      });
      await complete.future;
      if (machineId.isEmpty) {
        emit(ConnectToMachineFailureState(message: "Failed To Connect"));
        return;
      }
      final jsonResponse = await http.get(Uri.parse(
          "https://telephone.http.vsensetech.in/user/machine/balance/$machineId"));
      var response = jsonDecode(jsonResponse.body);
      if (jsonResponse.statusCode == 200) {
        emit(ConnectToMachineSuccessState(
            machineId: machineId,
            amount: response["balance"].toString(),
            connection: connection));
        return;
      }
      emit(ConnectToMachineFailureState(message: "Failed To Connect"));
    } catch (e) {
      emit(ConnectToMachineFailureState(message: "Failed To Connect"));
    }
  }
}
