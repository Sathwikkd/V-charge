
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<FetchHistoryEvent>(_fetchHistoryState);
  }
  Future<void> _fetchHistoryState(FetchHistoryEvent event , Emitter<HistoryState> emit) async {
    emit(FetchHistoryLoadingState());
    try {
      final response = await http.get(Uri.parse("https://telephone.http.vsensetech.in/user/expense/history/${event.machineId.toLowerCase()}"));
      final jsonResponse = jsonDecode(response.body);
      if(response.statusCode == 200){
        emit(FetchHistorySuccessState(data: jsonResponse["expense_history"]));
        return;
      }
      emit(FetchHistoryErrorState());
    } catch (e) {
      emit(FetchHistoryErrorState());
    }
  }
}
