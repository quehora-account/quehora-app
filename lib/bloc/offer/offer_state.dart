part of 'offer_bloc.dart';

sealed class OfferState {}

final class InitLoading extends OfferState {}

final class InitSuccess extends OfferState {
}
final class FirstTimeSuccess extends OfferState {
  List<List<Offer>> categories = [];
  FirstTimeSuccess({required this.categories});
}
final class InitFailed extends OfferState {
  final AlertException exception;

  InitFailed({required this.exception});
}
final class GetOffersSuccess extends OfferState {
  String searchText;
  bool doesFind=false;
  bool isSelectedBySpot=false;
  List<List<Offer>> categories = [];

  GetOffersSuccess({required this.categories,required this.searchText,required this.doesFind, this.isSelectedBySpot=false});
}
final class SuggestionEmptied extends OfferState {}

final class GetSuggestionsSuccess extends OfferState {
  List<dynamic> suggestion;
  GetSuggestionsSuccess({required this.suggestion});
}
final class UnlockLoading extends OfferState {}

final class UnlockSuccess extends OfferState {
  final UnlockedOffer unlockedOffer;

  UnlockSuccess({required this.unlockedOffer});
}

final class UnlockFailed extends OfferState {
  final AlertException exception;

  UnlockFailed({required this.exception});
}
