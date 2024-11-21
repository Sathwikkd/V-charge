part of 'pair_device_bloc.dart';

@immutable
sealed class PairDeviceEvent {}
 

class PairingDeviceEvent extends PairDeviceEvent{
    final String address;
    PairingDeviceEvent({required this.address});
}