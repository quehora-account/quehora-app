import * as admin from "firebase-admin";

export class LevelRepository {
  static async create(json: any): Promise<void> {
    await admin.firestore().collection("level").add(json);
  }
}
