import * as admin from "firebase-admin";

export class TransactionRepository {
  static async create(json: any): Promise<void> {
    await admin.firestore().collection("transaction").add(json);
  }
}
