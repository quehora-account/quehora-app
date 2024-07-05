import * as admin from "firebase-admin";
import {OfferEntity} from "../common/entity/offer.entity";

export class OfferRepository {
  static async create(json : any) : Promise<void> {
    await admin.firestore().collection("offer").add(json);
  }

  static async getById(offerId: string) : Promise<OfferEntity> {
    const snapshot = await admin.firestore().collection("offer").doc(offerId).get();
    return OfferEntity.fromSnapshot(snapshot);
  }

  static async createUnlockOffer(json: any) : Promise<void> {
    await admin.firestore().collection("unlockedOffer").add(json);
  }

  static async updateCodes(offerId: string, codes: string[]) : Promise<void> {
    await admin.firestore().collection("offer").doc(offerId).update({
      "codes": codes,
    });
  }
}
