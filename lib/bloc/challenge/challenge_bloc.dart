import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/challenge_model.dart';
import 'package:hoora/model/unlocked_challenge_model.dart';
import 'package:hoora/repository/challenge_repository.dart';
import 'package:hoora/repository/crash_repository.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final CrashRepository crashRepository;
  final ChallengeRepository challengeRepository;

  late List<Challenge> challenges;

  ChallengeBloc({
    required this.crashRepository,
    required this.challengeRepository,
  }) : super(InitLoading()) {
    on<Init>(init);
    on<ClaimChallenge>(claimChallenge);
  }

  void init(Init event, Emitter<ChallengeState> emit) async {
    try {
      emit(InitLoading());
      List futures = await Future.wait([
        challengeRepository.getAllChallenges(),
        challengeRepository.getUnlockedChallenges(),
      ]);

      /// Attach unlocked challenges to challenges
      challenges = futures[0];
      List<UnlockedChallenge> unlockedChallenges = futures[1];

      for (UnlockedChallenge unlockedChallenge in unlockedChallenges) {
        for (Challenge challenge in challenges) {
          if (challenge.id == unlockedChallenge.challengeId) {
            challenge.unlockedChallenge = unlockedChallenge;
            break;
          }
        }
      }

      /// Sorted by priority order
      challenges.sort((a, b) {
        return a.priority.compareTo(b.priority);
      });

      /// Sort claimed challenges
      challenges.sort((a, b) {
        if (a.unlockedChallenge != null && a.unlockedChallenge!.status == ChallengeStatus.claimed) {
          return 1;
        }

        return 0;
      });

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void claimChallenge(ClaimChallenge event, Emitter<ChallengeState> emit) async {
    try {
      emit(ClaimLoading(challengeId: event.challenge.id));
      await challengeRepository.claimUnlockedChallenge(event.challenge.unlockedChallenge!.id);

      /// Update challenge status
      for (int i = 0; i < challenges.length; i++) {
        Challenge challenge = challenges[i];
        if (challenge.id == event.challenge.id) {
          challenge.unlockedChallenge!.status = ChallengeStatus.claimed;

          /// Re place it at the end of the list
          challenges.removeAt(i);
          challenges.add(challenge);
          break;
        }
      }

      emit(ClaimSuccess(
        unlockedChallenge: event.challenge.unlockedChallenge!,
        gem: event.challenge.unlockedChallenge!.gem,
      ));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ClaimFailed(exception: alertException));
    }
  }
}
