part of 'user_bloc.dart';

sealed class UserState {}

final class InitLoading extends UserState {}

final class InitSuccess extends UserState {}

final class UnlockedOffersUpdate extends UserState {
  final List<Offer> offers;

  UnlockedOffersUpdate({required this.offers});
}

final class GemsUpdate extends UserState {
  final int gems;

  GemsUpdate({required this.gems});
}

final class InitFailed extends UserState {
  final AlertException exception;

  InitFailed({required this.exception});
}

final class SetNicknameLoading extends UserState {}

final class SetNicknameSuccess extends UserState {}

final class NicknameNotAvailable extends UserState {
  final String nickname;

  NicknameNotAvailable({required this.nickname});
}

final class SetNicknameFailed extends UserState {
  final AlertException exception;

  SetNicknameFailed({required this.exception});
}

final class UpdateProfileLoading extends UserState {}

final class UpdateProfileSuccess extends UserState {}

final class UpdateProfileFailed extends UserState {
  final AlertException exception;

  UpdateProfileFailed({required this.exception});
}

final class ActivateUnlockedOfferLoading extends UserState {}

final class ActivateUnlockedOfferSuccess extends UserState {}

final class ActivateUnlockedOfferFailed extends UserState {
  final AlertException exception;

  ActivateUnlockedOfferFailed({required this.exception});
}
