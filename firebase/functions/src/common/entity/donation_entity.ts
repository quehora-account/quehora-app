import {DocumentData} from "firebase-admin/firestore";

export class UnlockedOfferEntity {
  id: string;
  projectId: string;
  userId: string;
  gem: number;
  createdAt: Date;

  constructor({id, projectId, userId, gem, createdAt} : {
      id: string;
      projectId: string;
      userId: string;
      gem: number;
      createdAt: Date;
        }) {
    this.id = id;
    this.projectId = projectId;
    this.userId = userId;
    this.gem = gem;
    this.createdAt = createdAt;
  }

  static fromSnapshot(snapshot: DocumentData): UnlockedOfferEntity {
    const json = snapshot.data();
    const entity = new UnlockedOfferEntity({
      id: snapshot.id,
      projectId: json.projectId,
      userId: json.userId,
      gem: json.gem,
      createdAt: json.createdAt,
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): UnlockedOfferEntity[] {
    const list: UnlockedOfferEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = UnlockedOfferEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
