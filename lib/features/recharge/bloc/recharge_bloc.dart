import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  RechargeBloc() : super(RechargeInitial()) {
    on<RechargeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
