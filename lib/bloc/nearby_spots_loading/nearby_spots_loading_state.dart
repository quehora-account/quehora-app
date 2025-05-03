part of 'nearby_spots_loading_bloc.dart';


sealed class NearbySpotsLoadingState {}

final class NearbySpotsLoaded extends NearbySpotsLoadingState {
  final List<Spot> spots;
  final LatLng pos;
  NearbySpotsLoaded({required this.spots,required this.pos});
}

final class NearbySpotsLoadingLoading extends NearbySpotsLoadingState {}

final class NearbySpotsLoadingFailed extends NearbySpotsLoadingState {
  final AlertException exception;

  NearbySpotsLoadingFailed({required this.exception});
}
