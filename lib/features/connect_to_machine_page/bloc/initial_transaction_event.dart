part of 'initial_transaction_bloc.dart';

@immutable
sealed class InitialTransactionEvent {}

class FetchAllDetailsEvent extends InitialTransactionEvent{
  final String address;
  FetchAllDetailsEvent({required this.address});
}
