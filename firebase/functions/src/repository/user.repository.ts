import * as admin from "firebase-admin";
import {UserEntity} from "../common/entity/user.entity";

export class UserRepository {
  static async getUser(userId: string): Promise<UserEntity> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    return user;
  }

  static async getAll(): Promise<UserEntity[]> {
    const snapshot = await admin.firestore().collection("user").get();
    const users = UserEntity.fromSnapshots(snapshot.docs);
    return users;
  }

  /**
 *
 * @param documentId
 * @param gem
 * @param amountOfferUnlocked
 */
  static async updateUserAfterUnlockingOffer(documentId: string, gem: number, amountOfferUnlocked: number): Promise<void> {
    await admin.firestore().collection("user").doc(documentId).update({
      gem: gem,
      amountOfferUnlocked: amountOfferUnlocked,
    });
  }


  /**
   *
   * @param documentId
   * @param gem
   * @param amountSpotValidated
   * @param experience
   */
  static async updateUserAftervalidatingSpot(documentId: string, gem: number, experience: number, amountSpotValidated: number): Promise<void> {
    await admin.firestore().collection("user").doc(documentId).update({
      gem: gem,
      experience: experience,
      amountSpotValidated: amountSpotValidated,
    });
  }

  /**
   *
   * @param documentId
   * @param gem
   * @param experience
   * @param amountCrowdReportCreated
   */
  static async updateUserAfterCreatingReport(documentId: string, gem: number, experience: number, amountCrowdReportCreated: number): Promise<void> {
    await admin.firestore().collection("user").doc(documentId).update({
      gem: gem,
      experience: experience,
      amountCrowdReportCreated: amountCrowdReportCreated,
    });
  }

  /**
   *
   * @param documentId
   * @param gem
   * @param amountDonation
   */
  static async updateUserAfterDonation(documentId: string, gem: number, amountDonation: number): Promise<void> {
    await admin.firestore().collection("user").doc(documentId).update({
      gem: gem,
      amountDonation: amountDonation,
    });
  }
}
