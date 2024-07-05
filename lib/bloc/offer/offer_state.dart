part of 'offer_bloc.dart';

sealed class OfferState {}

final class InitLoading extends OfferState {}

final class InitSuccess extends OfferState {}

final class InitFailed extends OfferState {
  final AlertException exception;

  InitFailed({required this.exception});
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
