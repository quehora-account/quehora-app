part of 'challenge_bloc.dart';

sealed class ChallengeEvent {}

class Init extends ChallengeEvent {}

class ClaimChallenge extends ChallengeEvent {
  final Challenge challenge;

  ClaimChallenge({required this.challenge});
}
