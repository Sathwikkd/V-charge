import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial()) {
    on<HandlePermissionEvent>(_handlePermission);
    on<FetchBluetoothDevicesEvent>(_fetchDevices);
  }
  Future<void> _handlePermission(
      HandlePermissionEvent event, Emitter<DeviceState> emit) async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.bluetoothAdvertise.request().isGranted &&
        await Permission.location.request().isGranted) {
      emit(PermissionSuccessState());
    } else {
      SystemNavigator.pop();
      emit(PermissionErrorState());
    }
  }

  Future<void> _fetchDevices(
      FetchBluetoothDevicesEvent event, Emitter<DeviceState> emit) async {
    emit(LoadingState());
    try {
      final FlutterBluetoothSerial bluetoothSerial =
          FlutterBluetoothSerial.instance;
      final List<BluetoothDevice> bondedDevices = await bluetoothSerial.getBondedDevices();
          
      if (bondedDevices.isEmpty) {
        emit(FetchDeviceErrorState(message: "No Devices Found..."));
        return;
      }
      emit(FetchDeviceSuccesState(devices: bondedDevices));
    } catch (e) {
      emit(FetchDeviceErrorState(
          message: "Failed to fetch Bluetooth devices: $e"));
    }
  }
}
