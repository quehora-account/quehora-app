import * as admin from "firebase-admin";
import {ChallengeEntity} from "../common/entity/challenge_entity";

export class ChallengeRepository {
  static async getChallengeById(documentId: string): Promise<ChallengeEntity> {
    const doc = await admin.firestore().collection("challenge").doc(documentId).get();
    const spot = ChallengeEntity.fromSnapshot(doc);
    return spot;
  }

  static async isUnlocked(userId: string, challengeId: string): Promise<boolean> {
    const snapshot = await admin.firestore().collection("unlockedChallenge")
      .where("userId", "==", userId)
      .where("challengeId", "==", challengeId)
      .get();

    if (snapshot.docs.length > 0) {
      return true;
    }
    return false;
  }
}
