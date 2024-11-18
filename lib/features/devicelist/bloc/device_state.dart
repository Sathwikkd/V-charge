part of 'device_bloc.dart';

@immutable
sealed class DeviceState {}

final class DeviceInitial extends DeviceState {}

final class PermissionErrorState extends DeviceState{}

final class PermissionSuccessState extends DeviceState{}

final class LoadingState extends DeviceState{}

final class FetchDeviceSuccesState extends DeviceState{
  final List<BluetoothDevice>devices;
  FetchDeviceSuccesState({required this.devices});
}

final class FetchDeviceErrorState extends DeviceState{
  final String message;
  FetchDeviceErrorState({required this.message});
}
