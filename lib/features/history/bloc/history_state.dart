part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}


final class FetchHistorySuccessState extends HistoryState{
  final dynamic data;
  FetchHistorySuccessState({required this.data});
}


final class FetchHistoryErrorState extends HistoryState{}


final class FetchHistoryLoadingState extends HistoryState{}