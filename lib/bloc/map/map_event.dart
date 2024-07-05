part of 'map_bloc.dart';

sealed class MapEvent {}

final class Init extends MapEvent {}

final class PlaylistSelected extends MapEvent {
  final Playlist? playlist;

  PlaylistSelected({required this.playlist});
}

final class GetSpots extends MapEvent {}

final class RegionSelected extends MapEvent {
  final Region region;
  final City? city;

  RegionSelected({required this.region, this.city});
}

final class DateSelected extends MapEvent {
  final DateTime date;

  DateSelected({required this.date});
}

final class HourSelected extends MapEvent {
  final int hour;

  HourSelected({required this.hour});
}

final class UpdateDate extends MapEvent {
  final DateTime date;

  UpdateDate({required this.date});
}
