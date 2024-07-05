part of 'user_bloc.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class AddGem extends UserEvent {
  final int gem;

  AddGem({required this.gem});
}

final class RemoveGem extends UserEvent {
  final int gem;

  RemoveGem({required this.gem});
}

final class AddUnlockedOffer extends UserEvent {
  final Offer offer;

  AddUnlockedOffer({required this.offer});
}

final class ActivateUnlockedOffer extends UserEvent {
  final Offer offer;

  ActivateUnlockedOffer({required this.offer});
}

final class SetNickname extends UserEvent {
  final String nickname;

  SetNickname({required this.nickname});
}

final class UpdateProfile extends UserEvent {
  final String nickname;
  final String firstname;
  final String lastname;
  final String city;
  final String country;
  final DateTime? birthday;
  final Gender gender;

  final bool hasNicknameChanged;

  UpdateProfile({
    required this.nickname,
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.country,
    required this.birthday,
    required this.gender,
    required this.hasNicknameChanged,
  });
}
