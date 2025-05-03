part of 'explore_bloc.dart';

sealed class ExploreState {}

final class InitLoading extends ExploreState {}

final class SpotsLoading extends ExploreState {}

final class InitSuccess extends ExploreState {}

final class CitySelectedUpdated extends ExploreState {}

final class InitFailed extends ExploreState {
  final AlertException exception;

  InitFailed({required this.exception});
}

final class GetSpotsSuccess extends ExploreState {
  String searchText;
  bool doesFind=false;
  bool isSelectedBySpot=false;
  bool applyZooming = true;
  GetSpotsSuccess({required this.searchText,required this.doesFind, this.isSelectedBySpot=false,this.applyZooming = true});
}

final class GetSuggestionsSuccess extends ExploreState {
  List<dynamic> suggestion;
  GetSuggestionsSuccess({required this.suggestion});
}

final class GetSpotsLoading extends ExploreState {}

final class SuggestionEmptied extends ExploreState {}

final class GetSpotsFailed extends ExploreState {
  final AlertException exception;

  GetSpotsFailed({required this.exception});
}
