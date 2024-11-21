part of 'initial_transaction_bloc.dart';

@immutable
sealed class InitialTransactionState {}

final class InitialTransactionInitial extends InitialTransactionState {}

final class FetchAllDetailsSuccessState extends InitialTransactionState{
  final String machineId;
  final String balance;
  FetchAllDetailsSuccessState({required this.machineId , required this.balance});
}

final class FetchAllDetailsErrorState extends InitialTransactionState{
  final String message;
  FetchAllDetailsErrorState({required this.message});
}

final class FetchAllDetaailsLoadingState extends InitialTransactionState{}
