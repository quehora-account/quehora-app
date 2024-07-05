import {DocumentData} from "firebase-admin/firestore";

export class DonationEntity {
  id: string;
  projectId: string;
  userId: string;
  createdAt: Date;
  gem: number;

  constructor({id, projectId, gem, userId, createdAt} : {
          id: string,
          projectId: string,
          userId: string,
          gem: number,
          createdAt: Date,

      }) {
    this.id = id;
    this.projectId = projectId;
    this.userId = userId;
    this.gem = gem;
    this.createdAt = createdAt;
  }

  static fromSnapshot(snapshot: DocumentData): DonationEntity {
    const json = snapshot.data();
    const entity = new DonationEntity({
      id: snapshot.id,
      projectId: json.projectId,
      userId: json.userId,
      gem: json.gem,
      createdAt: json.createdAt,
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): DonationEntity[] {
    const list: DonationEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = DonationEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
