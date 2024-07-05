import * as admin from "firebase-admin";

export class CrowdReportRepository {
  static async create(json: any): Promise<void> {
    await admin.firestore().collection("crowdReport").add(json);
  }
}
