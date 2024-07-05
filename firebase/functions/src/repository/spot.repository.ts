import * as admin from "firebase-admin";
import {SpotEntity} from "../common/entity/spot.entity";
import {SpotValidatedEntity} from "../common/entity/spot_validated";

export class SpotRepository {
  static async getSpotById(documentId: string): Promise<SpotEntity> {
    const spotDoc = await admin.firestore().collection("spot").doc(documentId).get();
    const spot = SpotEntity.fromSnapshot(spotDoc);
    return spot;
  }


  static async updateLastCrowdReport(documentId: string, lastCrowdReport: any): Promise<void> {
    await admin.firestore().collection("spot").doc(documentId).update({lastCrowdReport: lastCrowdReport});
  }

  static async setTrafficPoints(documentId: string, trafficPoints: object[]): Promise<void> {
    await admin.firestore().collection("spot").doc(documentId).update({"trafficPoints": trafficPoints});
  }

  static async create(json: any): Promise<void> {
    await admin.firestore().collection("spot").add(json);
  }

  static async createSpotValidation(json: any): Promise<void> {
    await admin.firestore().collection("spotValidation").add(json);
  }

  static async getSpotsValidated(userId: string): Promise<SpotValidatedEntity[]> {
    const snapshotSv = await admin.firestore().collection("spotValidation")
      .where("userId", "==", userId)
      .get();
    return SpotValidatedEntity.fromSnapshots(snapshotSv.docs);
  }
}
