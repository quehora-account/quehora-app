part of 'challenge_bloc.dart';

sealed class ChallengeState {}

class InitLoading extends ChallengeState {}

final class InitSuccess extends ChallengeState {}

final class InitFailed extends ChallengeState {
  final AlertException exception;

  InitFailed({required this.exception});
}

class ClaimLoading extends ChallengeState {
  final String challengeId;

  ClaimLoading({required this.challengeId});
}

final class ClaimSuccess extends ChallengeState {
  final UnlockedChallenge unlockedChallenge;
  final int gem;

  ClaimSuccess({required this.unlockedChallenge, required this.gem});
}

final class ClaimFailed extends ChallengeState {
  final AlertException exception;

  ClaimFailed({required this.exception});
}
