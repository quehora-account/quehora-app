import {DocumentData} from "firebase-admin/firestore";

export class SpotValidatedEntity {
  id: string;
  userId: string;
  spotId: string;
  gem: number;
  createdAt: Date;

  constructor({id, userId, spotId, gem, createdAt} : {
          id: string,
          userId: string,
          spotId: string,
          gem: number,
          createdAt: Date,
        }) {
    this.id = id;
    this.userId = userId;
    this.spotId = spotId;
    this.gem = gem;
    this.createdAt = createdAt;
  }

  static fromSnapshot(snapshot: DocumentData): SpotValidatedEntity {
    const json = snapshot.data();
    const dto = new SpotValidatedEntity({
      id: snapshot.id,
      userId: json.userId,
      spotId: json.spotId,
      gem: json.gems,
      createdAt: json.createdAt.toDate(),
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): SpotValidatedEntity[] {
    const list: SpotValidatedEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = SpotValidatedEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
