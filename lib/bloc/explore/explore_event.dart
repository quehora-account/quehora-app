part of 'explore_bloc.dart';

sealed class ExploreEvent {}

final class Init extends ExploreEvent {}

final class PlaylistSelected extends ExploreEvent {
  final Playlist? playlist;

  PlaylistSelected({required this.playlist});
}
final class EmptySuggestions extends ExploreEvent {}

final class GetSuggestions extends ExploreEvent {
  String search;
  GetSuggestions({required this.search});
}

final class SelectRegionByPosition extends ExploreEvent {
  Region region;
  SelectRegionByPosition({required this.region});
}

final class CitySelected extends ExploreEvent {
  City city;
  CitySelected({required this.city});
}

final class SpotSelected extends ExploreEvent {
  Spot spot;
  SpotSelected({required this.spot});
}


final class SearchSpots extends ExploreEvent {
  String search;
  SearchSpots({required this.search});
}

final class FilterSelected extends ExploreEvent {
  final DateTime date;
  final String sortingType;
  final String zone;
  final bool openSpots;

  FilterSelected({required this.date,required this.sortingType,required this.zone,required this.openSpots});
}

final class HourSelected extends ExploreEvent {
  final int hour;

  HourSelected({required this.hour});
}
