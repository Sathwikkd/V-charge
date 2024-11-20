part of 'unpaired_devices_bloc.dart';

@immutable
sealed class UnpairedDevicesState {}

final class UnpairedDevicesInitial extends UnpairedDevicesState {}

final class FetchUnpairedDevicesSuccessState extends UnpairedDevicesState {
  final List<BluetoothDiscoveryResult> updevices;
  FetchUnpairedDevicesSuccessState({required this.updevices});
}

final class FetchUnpairedDevicesErrorState extends UnpairedDevicesState{
  final String message;
  FetchUnpairedDevicesErrorState({required this.message});
}

final class FetchUnpairedDevicesLoadingState extends UnpairedDevicesState{}