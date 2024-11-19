import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  RechargeBloc() : super(RechargeInitial()) {
    on<FetchCardBalance>(_fetchCardBalance);
  }
  Future<void> _fetchCardBalance(FetchCardBalance event, Emitter<RechargeState> emit) async {
    try {
      event.connection.output.add(
      ascii.encode(
        jsonEncode({"st": 2}),
      ),
    );
    var completer = Completer<void>();
   StringBuffer buffer = StringBuffer();
    String balance = "";
    event.connection.input!.listen((Uint8List data){
      print(ascii.decode(data));
        //  buffer.write(utf8.decode(data));
        // if(buffer.toString().endsWith("}")){
        //   // var res = jsonDecode(jsonMessage);
        //   // balance = res["bl"].toString();
        //   print(buffer.toString());
        //   completer.complete();
        // }
    });
    await completer.future;
    if(balance.isEmpty){
      emit(FetchCardBalanceErrorState(message: "Failed Try Again..."));
      return;
    }
    emit(FetchCardBalanceSuccessState(balance: balance));
    } catch (e) {
      emit(FetchCardBalanceErrorState(message: e.toString()));
    }
  }
}
