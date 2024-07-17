import * as gcloud from "@google-cloud/firestore";

export class LastCrowdReportEntity {
  createdAt: Date;
  userId: string;
  duration: string;
  intensity: number;
  coordinates: gcloud.GeoPoint; // Ajout du champ coordinates

  constructor({ createdAt, userId, duration, intensity, coordinates }: {
          createdAt: Date,
          userId: string,
          duration: string,
          intensity: number,
    coordinates: gcloud.GeoPoint // Ajout du champ coordinates
      }) {
    this.createdAt = createdAt;
    this.userId = userId;
    this.duration = duration;
    this.intensity = intensity;
    this.coordinates = coordinates; // Initialisation du champ coordinates
  }

  static fromJson(json: any | null): LastCrowdReportEntity | null {
    if (json == null) {
      return null;
    }

    console.log(json.createdAt.toDate());
    console.log(json.userId);
    console.log(json.duration);
    console.log(json.intensity);
    console.log(json.coordinates['_latitude']);
    console.log(json.coordinates['_longitude']);
    console.log(new gcloud.GeoPoint(json.coordinates['_latitude'], json.coordinates['_longitude']));

    const entity = new LastCrowdReportEntity({
      createdAt: json.createdAt.toDate(),
      userId: json.userId,
      duration: json.duration,
      intensity: json.intensity,
      coordinates: new gcloud.GeoPoint(json.coordinates['_latitude'], json.coordinates['_longitude']) // Conversion de json en GeoPoint
    });
    return entity;
  }

  static fromJsons(jsons: any[]): LastCrowdReportEntity[] {
    const list: LastCrowdReportEntity[] = [];
    for (const json of jsons) {
      const elem = LastCrowdReportEntity.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson(): object {
    return {
      "createdAt": this.createdAt,
      "userId": this.userId,
      "duration": this.duration,
      "intensity": this.intensity,
      "coordinates": this.coordinates, // Ajout du champ coordinates dans la méthode toJson
    };
  }

  static toJsons(reports: LastCrowdReportEntity[]): object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
