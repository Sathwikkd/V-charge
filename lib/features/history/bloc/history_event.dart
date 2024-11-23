part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}


final class FetchHistoryEvent extends HistoryEvent{
  final String machineId;
  FetchHistoryEvent({required this.machineId});
}
