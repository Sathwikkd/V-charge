part of 'device_bloc.dart';

@immutable
sealed class DeviceEvent {}


class HandlePermissionEvent extends DeviceEvent{}


class FetchBluetoothDevicesEvent extends DeviceEvent{}


class CheckConnectionEvent extends DeviceEvent{}
