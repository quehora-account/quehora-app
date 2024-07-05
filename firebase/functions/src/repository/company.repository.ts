import * as admin from "firebase-admin";
import {CompanyEntity} from "../common/entity/company.entity";

export class CompanyRepository {
  static async create(json : any) : Promise<void> {
    await admin.firestore().collection("company").add(json);
  }

  static async getById(companyId: string) : Promise<CompanyEntity> {
    const snapshot = await admin.firestore().collection("company").doc(companyId).get();
    return CompanyEntity.fromSnapshot(snapshot);
  }
}
