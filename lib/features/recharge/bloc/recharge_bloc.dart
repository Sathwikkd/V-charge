import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  RechargeBloc() : super(RechargeInitial()) {
    on<FetchMachineBalanceEvent>(_fetchMachineBalance);
    on<RechargeCardEvent>(_rechargeCard);
  }

  Future<void> _fetchMachineBalance(
      FetchMachineBalanceEvent event, Emitter<RechargeState> emit) async {
    try {
      emit(FetchMachineBalanceLoadingState());
      final response = await http.get(
          Uri.parse(
              "https://telephone.http.vsensetech.in/user/machine/balance/${event.machineID.toLowerCase()}"),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        emit(FetchMachineBalanceFailureState(
            message: "Unable to fetch balance. Please try again."));
        return;
      }

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse == null || jsonResponse['balance'] == null) {
        emit(FetchMachineBalanceFailureState(
            message: "Invalid response from the server."));
        return;
      }

      emit(FetchMachineBalanceSuccessState(
          mbalance: jsonResponse['balance'].toString()));
    } catch (e) {
      emit(FetchMachineBalanceFailureState(
          message: "An error occurred."));
    }
  }

  Future<void> _rechargeCard(
      RechargeCardEvent event, Emitter<RechargeState> emit) async {
        emit(RechargeCardLoadingState());
    if (event.amount.isEmpty || int.parse(event.amount) > int.parse(event.mbalance)) {
      emit(RechargeCardErrorState(message: "Enter a valid amount"));
      return;
    }

    BluetoothConnection? connection;
    try {
      connection = await BluetoothConnection.toAddress(event.address);
      final dataToSend = jsonEncode({
        "st": 3,
        "amt": int.parse(event.amount) + int.parse(event.balance)
      });
      connection.output.add(utf8.encode(dataToSend));

      final StringBuffer buffer = StringBuffer();
      final Completer<void> completer = Completer<void>();
      int errSt = 0;

      connection.input!.listen(
        (Uint8List data) {
          buffer.write(utf8.decode(data));
          if (buffer.toString().startsWith("{") &&
              buffer.toString().endsWith("}")) {
            try {
              var res = jsonDecode(buffer.toString());
              if (res['mty'] == 3) {
                errSt = res['est'];
                buffer.clear();
                completer.complete();
              }
            } catch (_) {
              emit(RechargeCardErrorState(
                  message: "Invalid response received from the machine."));
              buffer.clear();
              completer.completeError("Invalid response");
            }
          }
        },
        onError: (error) {
          emit(RechargeCardErrorState(
              message: "Error reading data: ${error.toString()}"));
          completer.completeError(error);
        },
        cancelOnError: true,
      );

      await completer.future;
       connection.dispose();

      if (errSt == 0) {
        final deductResponse = await http.post(
          Uri.parse(
              "https://telephone.http.vsensetech.in/user/deduct/machine/balance/${event.machineID.toLowerCase()}"),
          body: jsonEncode({"amount": int.parse(event.amount)}),
        );

        if (deductResponse.statusCode != 200) {
          emit(RechargeCardErrorState(
              message: "Recharge successful, but server update failed."));
          return;
        }
        emit(RechargeCardSuccessState(message: "Recharge successful!"));
      } else {
        emit(RechargeCardErrorState(message: "Machine rejected the recharge."));
      }
    } catch (e) {
      emit(RechargeCardErrorState(
          message: "An error occurred"));
    } finally {
      connection?.dispose();
    }
  }
}
