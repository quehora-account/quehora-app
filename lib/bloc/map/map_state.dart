part of 'map_bloc.dart';

sealed class MapState {}

final class InitLoading extends MapState {}

final class InitSuccess extends MapState {}

final class InitFailed extends MapState {
  final AlertException exception;

  InitFailed({required this.exception});
}

final class CitySelectedUpdated extends MapState {}

final class GetSpotsSuccess extends MapState {}

final class GetSpotsLoading extends MapState {}

final class GetSpotsFailed extends MapState {
  final AlertException exception;

  GetSpotsFailed({required this.exception});
}
