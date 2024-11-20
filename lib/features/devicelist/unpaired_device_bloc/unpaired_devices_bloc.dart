import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'unpaired_devices_event.dart';
part 'unpaired_devices_state.dart';

class UnpairedDevicesBloc extends Bloc<UnpairedDevicesEvent, UnpairedDevicesState> {
  UnpairedDevicesBloc() : super(UnpairedDevicesInitial()) {
    on<FetchUnpairedDevices>(_unpairedDeviceStream);
  }

  Future<void> _unpairedDeviceStream( FetchUnpairedDevices event, Emitter<UnpairedDevicesState> emit ) async {
    final completer = Completer<void>();
    final FlutterBluetoothSerial bluetoothInstance = FlutterBluetoothSerial.instance;
    List<BluetoothDiscoveryResult> upDevices = [];
    List<String> address = [];
    emit(FetchUnpairedDevicesLoadingState());
    bluetoothInstance.startDiscovery().listen((data){
      if(!address.contains(data.device.address)){
        address.add(data.device.address);
        upDevices.add(data);
      }
    }).onDone((){
      completer.complete();
    });
    await completer.future;
    if(upDevices.isEmpty) {
      emit(FetchUnpairedDevicesErrorState(message: "No Devices Found..."));
      return;
    }
    emit(FetchUnpairedDevicesSuccessState(updevices: upDevices));
  }
}

