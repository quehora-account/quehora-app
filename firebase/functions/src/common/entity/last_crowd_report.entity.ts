export class LastCrowdReportEntity {
  createdAt: Date;
  userId: string;
  duration: string;
  intensity: number;

  constructor({createdAt, userId, duration, intensity} : {
          createdAt: Date,
          userId: string,
          duration: string,
          intensity: number,

      }) {
    this.createdAt = createdAt;
    this.userId = userId;
    this.duration = duration;
    this.intensity = intensity;
  }

  static fromJson(json: any | null): LastCrowdReportEntity | null {
    if (json == null) {
      return null;
    }

    const entity = new LastCrowdReportEntity({
      createdAt: json.createdAt.toDate(),
      userId: json.userId,
      duration: json.duration,
      intensity: json.intensity,
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

  toJson() : object {
    return {
      "createdAt": this.createdAt,
      "userId": this.userId,
      "duration": this.duration,
      "intensity": this.intensity,
    };
  }

  static toJsons(reports : LastCrowdReportEntity[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
