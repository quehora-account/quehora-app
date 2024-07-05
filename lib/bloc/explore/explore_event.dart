part of 'explore_bloc.dart';

sealed class ExploreEvent {}

final class Init extends ExploreEvent {}

final class PlaylistSelected extends ExploreEvent {
  final Playlist? playlist;

  PlaylistSelected({required this.playlist});
}

final class GetSpots extends ExploreEvent {}

final class RegionSelected extends ExploreEvent {
  final Region region;
  final City? city;

  RegionSelected({required this.region, this.city});
}

final class DateSelected extends ExploreEvent {
  final DateTime date;

  DateSelected({required this.date});
}

final class HourSelected extends ExploreEvent {
  final int hour;

  HourSelected({required this.hour});
}
