part of 'pair_device_bloc.dart';

@immutable
sealed class PairDeviceState {}

final class PairDeviceInitial extends PairDeviceState {}


final class PairingDeviceSuccessState extends PairDeviceState{}

final class PairingDeviceErrorState extends PairDeviceState{
  final String message;
  PairingDeviceErrorState({required this.message});
}