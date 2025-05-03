part of 'offer_bloc.dart';

sealed class OfferEvent {}

final class Init extends OfferEvent {}
final class FirstTime extends OfferEvent {}

final class Unlock extends OfferEvent {
  final Offer offer;
  final bool isFromSpotPage;
  Unlock({required this.offer,required this.isFromSpotPage});
}

final class GetSuggestions extends OfferEvent {
  String search;
  GetSuggestions({required this.search});
}

final class EmptySuggestions extends OfferEvent {}

final class CitySelected extends OfferEvent {
  City city;
  CitySelected({required this.city});
}

final class SearchOffers extends OfferEvent {
  String search;
  SearchOffers({required this.search});
}