import * as admin from "firebase-admin";
import {ProjectEntity} from "../common/entity/project.entity";
import {DonationEntity} from "../common/entity/donation.entity";

export class ProjectRepository {
  static async create(json : any) : Promise<void> {
    await admin.firestore().collection("project").add(json);
  }

  static async createDonation(json : any) : Promise<void> {
    await admin.firestore().collection("donation").add(json);
  }

  static async updateCollectedGem(documentId: string, collected: number) : Promise<void> {
    await admin.firestore().collection("project").doc(documentId).update({"collected": collected});
  }

  static async getProjectById(projectId: string): Promise<ProjectEntity> {
    const snapshot = await admin.firestore().collection("project").doc(projectId).get();
    const project = ProjectEntity.fromSnapshot(snapshot);
    return project;
  }

  static async getDonations(userId: string): Promise<DonationEntity[]> {
    const snapshot = await admin.firestore().collection("donation").where("userId", "==", userId).get();
    const donations = DonationEntity.fromSnapshots(snapshot.docs);
    return donations;
  }
}
