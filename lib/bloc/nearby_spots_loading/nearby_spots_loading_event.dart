part of 'nearby_spots_loading_bloc.dart';

sealed class NearbySpotsLoadingEvent {}

final class SearchNearBySpots extends NearbySpotsLoadingEvent {
  final LatLng userPosition;

  SearchNearBySpots({
    required this.userPosition,
  });
}


final class NearbySpotsLoading extends NearbySpotsLoadingEvent {
}
