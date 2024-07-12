import { DocumentData } from "firebase-admin/firestore";
import * as gcloud from "@google-cloud/firestore";

export class CrowdReportEntity {
  createdAt: Date;
  id: string;
  userId: string;
  spotId: string;
  duration: string;
  intensity: number;
  coordinates: gcloud.GeoPoint; // Ajout du champ coordinates

  constructor({ createdAt, userId, id, spotId, duration, intensity, coordinates }: {
          createdAt: Date,
          userId: string,
          spotId: string,
          id: string,
          duration: string,
          intensity: number,
    coordinates: gcloud.GeoPoint // Ajout du champ coordinates
      }) {
    this.createdAt = createdAt;
    this.userId = userId;
    this.spotId = spotId;
    this.id = id;
    this.duration = duration;
    this.intensity = intensity;
    this.coordinates = coordinates; // Initialisation du champ coordinates
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
      coordinates: new gcloud.GeoPoint(json.coordinates[0], json.coordinates[1]) // Conversion de json en GeoPoint
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
