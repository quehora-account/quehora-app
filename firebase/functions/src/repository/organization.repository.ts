import * as admin from "firebase-admin";

export class OrganizationRepository {
  static async create(json : any) : Promise<void> {
    await admin.firestore().collection("organization").add(json);
  }
}
