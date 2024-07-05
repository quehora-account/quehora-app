import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:hoora/model/challenge_model.dart';
import 'package:hoora/model/unlocked_challenge_model.dart';
import 'package:http/http.dart' as http;

class ChallengeRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<List<Challenge>> getAllChallenges() async {
    QuerySnapshot snapshot = await instance.collection("challenge").get();

    List<Challenge> challenges = Challenge.fromSnapshots(snapshot.docs);

    /// Post filtered.
    /// Should be made while querying firebase.
    List<Challenge> filteredChallenges = [];
    for (Challenge challenge in challenges) {
      DateTime now = DateTime.now();
      if (now.isAfter(challenge.from) && (challenge.to == null || now.isBefore(challenge.to!))) {
        filteredChallenges.add(challenge);
      }
    }

    return filteredChallenges;
  }

  Future<List<UnlockedChallenge>> getUnlockedChallenges() async {
    QuerySnapshot snapshot =
        await instance.collection("unlockedChallenge").where("userId", isEqualTo: authInstance.currentUser!.uid).get();

    List<UnlockedChallenge> challenges = UnlockedChallenge.fromSnapshots(snapshot.docs);
    return challenges;
  }

  Future<void> claimUnlockedChallenge(String unlockedChallengeId) async {
    // final url = Uri.parse('http://127.0.0.1:5001/hoora-fb944/us-central1/claimUnlockedChallenge');
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://claimunlockedchallenge-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://claimunlockedchallenge-5lgw4vxlaa-uc.a.run.app');
    await http.post(
      url,
      body: {
        'unlockedChallengeId': unlockedChallengeId,
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }
}
