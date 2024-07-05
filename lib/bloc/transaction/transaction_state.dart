part of 'transaction_bloc.dart';

sealed class TransactionState {}

final class InitLoading extends TransactionState {}

final class InitSuccess extends TransactionState {}

final class InitFailed extends TransactionState {
  final AlertException exception;

  InitFailed({required this.exception});
}
