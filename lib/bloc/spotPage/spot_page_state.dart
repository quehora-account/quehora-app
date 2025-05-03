part of 'spot_page_bloc.dart';

sealed class SpotPageState {}

final class InitLoading extends SpotPageState {}

final class InitSuccess extends SpotPageState {
  List<Offer> offers;
  InitSuccess({required this.offers});
}

final class InitFailed extends SpotPageState {
  final AlertException exception;

  InitFailed({required this.exception});
}