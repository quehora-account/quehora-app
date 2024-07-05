import 'package:cloud_firestore/cloud_firestore.dart';

enum ChallengeStatus { unlocked, claimed }

class UnlockedChallenge {
  final String id;
  final String challengeId;
  final int gem;
  ChallengeStatus status;

  UnlockedChallenge({
    required this.id,
    required this.challengeId,
    required this.gem,
    required this.status,
  });

  factory UnlockedChallenge.fromSnapshot(QueryDocumentSnapshot doc) {
    return UnlockedChallenge(
        id: doc.id,
        challengeId: doc['challengeId'],
        gem: doc['gem'],
        status: ChallengeStatus.values.byName(
          doc["status"],
        ));
  }

  static List<UnlockedChallenge> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<UnlockedChallenge> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(UnlockedChallenge.fromSnapshot(doc));
    }
    return list;
  }
}
