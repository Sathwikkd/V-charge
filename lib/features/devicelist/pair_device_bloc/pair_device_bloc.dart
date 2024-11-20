

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pair_device_event.dart';
part 'pair_device_state.dart';

class PairDeviceBloc extends Bloc<PairDeviceEvent, PairDeviceState> {
  PairDeviceBloc() : super(PairDeviceInitial()) {
    on<PairDeviceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
