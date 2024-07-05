part of 'ranking_bloc.dart';

sealed class RankingState {}

final class InitLoading extends RankingState {}

final class InitSuccess extends RankingState {}

final class InitFailed extends RankingState {
  final AlertException exception;

  InitFailed({required this.exception});
}
