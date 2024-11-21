import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';

part 'initial_transaction_event.dart';
part 'initial_transaction_state.dart';

class InitialTransactionBloc
    extends Bloc<InitialTransactionEvent, InitialTransactionState> {
  InitialTransactionBloc() : super(InitialTransactionInitial()) {
    on<FetchAllDetailsEvent>(_fetchAllDetails);
  }

  Future<void> _fetchAllDetails(
      FetchAllDetailsEvent event, Emitter<InitialTransactionState> emit) async {
    try {
      emit(FetchAllDetaailsLoadingState());
      // Cancel any ongoing Bluetooth discovery
      await FlutterBluetoothSerial.instance.cancelDiscovery();
      // Establish connection
      final BluetoothConnection newConnection =
          await BluetoothConnection.toAddress(event.address);

      // Prepare the output and input streams
      final completer = Completer<void>();
      final StringBuffer buffer = StringBuffer();
      String machineId = "";
      String balance = "";
      int errorStatus = 0;

      // Send initial request to fetch Machine ID
      newConnection.output.add(ascii.encode(jsonEncode({"st": 1})));

      newConnection.input!.listen((Uint8List data) {
        buffer.write(utf8.decode(data));
        // Ensure complete JSON is received
        if (buffer.toString().startsWith("{") && buffer.toString().endsWith("}")) {
          final response = jsonDecode(buffer.toString());
          buffer.clear(); // Clear the buffer after processing

          if (response['est'] == 0) {
            // Success response
            switch (response['mty']) {
              case 1:
                machineId = response['mid'].toString().toUpperCase();
                // Request card balance
                newConnection.output.add(ascii.encode(jsonEncode({"st": 2})));
                break;
              case 2:
                balance = response['bl'].toString();
                completer.complete(); // All required details fetched
                break;
            }
          } else if (response['est'] == 1) {
            // Handle error response
            errorStatus = response['ety'] ?? 0;
            completer.complete();
          }
        }
      }).onError((error) {
        completer.completeError(error);
      });

      // Await completion
      await completer.future;
      newConnection.dispose();

      // Emit appropriate states based on the fetched data
      if (machineId.isNotEmpty && balance.isNotEmpty) {
        emit(FetchAllDetailsSuccessState(
          machineId: machineId,
          balance: balance,
        ));
      } else {
        emit(_mapErrorToState(errorStatus));
      }
    } catch (e) {
      emit(FetchAllDetailsErrorState(message: "Try Connecting Again: $e"));
    }
  }

  // Map error codes to specific error messages
  FetchAllDetailsErrorState _mapErrorToState(int errorStatus) {
    switch (errorStatus) {
      case 1:
        return FetchAllDetailsErrorState(message: "JSON decode error");
      case 2:
        return FetchAllDetailsErrorState(message: "Press again to confirm");
      case 3:
        return FetchAllDetailsErrorState(message: "Failed to read RFID card ID");
      case 4:
        return FetchAllDetailsErrorState(message: "Invalid RFID card type");
      case 5:
        return FetchAllDetailsErrorState(
            message: "Failed to authenticate RFID card");
      case 6:
        return FetchAllDetailsErrorState(
            message: "Failed to read RFID card memory");
      case 7:
        return FetchAllDetailsErrorState(
            message: "Failed to write RFID card memory");
      case 8:
        return FetchAllDetailsErrorState(message: "Invalid option");
      default:
        return FetchAllDetailsErrorState(message: "Unhandled exception");
    }
  }
}
