import {DocumentData} from "firebase-admin/firestore";

export class CrowdReportEntity {
  createdAt: Date;
  id: string;
  userId: string;
  spotId: string;
  duration: string;
  intensity: number;

  constructor({createdAt, userId, id, spotId, duration, intensity} : {
          createdAt: Date,
          userId: string,
          spotId: string,
          id: string,
          duration: string,
          intensity: number,

      }) {
    this.createdAt = createdAt;
    this.userId = userId;
    this.spotId = spotId;
    this.id = id;
    this.duration = duration;
    this.intensity = intensity;
  }


  static fromSnapshot(snapshot: DocumentData): CrowdReportEntity {
    const json = snapshot.data();
    const dto = new CrowdReportEntity({
      id: snapshot.id,
      createdAt: json.createdAt.toDate(),
      userId: json.userId,
      spotId: json.spotId,
      duration: json.duration,
      intensity: json.intensity,

    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): CrowdReportEntity[] {
    const list: CrowdReportEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = CrowdReportEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
