part of 'offer_bloc.dart';

sealed class OfferEvent {}

final class Init extends OfferEvent {}

final class Unlock extends OfferEvent {
  final Offer offer;

  Unlock({required this.offer});
}
