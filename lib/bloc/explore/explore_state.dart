part of 'explore_bloc.dart';

sealed class ExploreState {}

final class InitLoading extends ExploreState {}

final class InitSuccess extends ExploreState {}

final class CitySelectedUpdated extends ExploreState {}

final class InitFailed extends ExploreState {
  final AlertException exception;

  InitFailed({required this.exception});
}

final class GetSpotsSuccess extends ExploreState {}

final class GetSpotsLoading extends ExploreState {}

final class GetSpotsFailed extends ExploreState {
  final AlertException exception;

  GetSpotsFailed({required this.exception});
}
