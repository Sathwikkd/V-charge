import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'pair_device_event.dart';
part 'pair_device_state.dart';

class PairDeviceBloc extends Bloc<PairDeviceEvent, PairDeviceState> {
  PairDeviceBloc() : super(PairDeviceInitial()) {
    on<PairingDeviceEvent>(_pairWithDevice);
  }
  Future<void> _pairWithDevice(
      PairingDeviceEvent event, Emitter<PairDeviceState> emit) async {
    try {
      bool? isPaired = await FlutterBluetoothSerial.instance
          .bondDeviceAtAddress(event.address);
      if (isPaired == null || !isPaired) {
        emit(PairingDeviceErrorState(
            message: "Unable to pair with the Device..."));
        return;
      }
      emit(PairingDeviceSuccessState());
    } catch (e) {
      emit(PairingDeviceErrorState(message: e.toString()));
    }
  }
}
