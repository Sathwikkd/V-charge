import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'unpaired_devices_event.dart';
part 'unpaired_devices_state.dart';

class UnpairedDevicesBloc
    extends Bloc<UnpairedDevicesEvent, UnpairedDevicesState> {
  UnpairedDevicesBloc() : super(UnpairedDevicesInitial()) {
    on<FetchUnpairedDevices>(_unpairedDeviceStream);
  }

  Future<void> _unpairedDeviceStream(
      FetchUnpairedDevices event, Emitter<UnpairedDevicesState> emit) async {
    try {
      final completer = Completer<void>();
      final FlutterBluetoothSerial bluetoothInstance = FlutterBluetoothSerial.instance;
      List<BluetoothDiscoveryResult> upDevices = [];
      List<BluetoothDiscoveryResult> ourDevices = [];
      List<String> address = [];
      await bluetoothInstance.cancelDiscovery();
      emit(FetchUnpairedDevicesLoadingState());
      List<BluetoothDevice> devices = await bluetoothInstance.getBondedDevices();
      bluetoothInstance.startDiscovery().listen((data) {
        if (!address.contains(data.device.address) && data.device.name != null && !devices.contains(data.device)) {
          address.add(data.device.address);
          upDevices.add(data);
        }
      }).onDone(() {
        completer.complete();
      });
      await completer.future;
      if (upDevices.isEmpty) {
        emit(FetchUnpairedDevicesErrorState(message: "No Devices Found..."));
        return;
      }
      for(int i = 0 ; i < upDevices.length ; i++){
        if(upDevices[i].device.name!.startsWith("VS")){
          ourDevices.add(upDevices[i]);
        }
      }
      emit(FetchUnpairedDevicesSuccessState(updevices: ourDevices));
    } catch (e) {
      emit(FetchUnpairedDevicesErrorState(message: e.toString()));
    }
  }
}
