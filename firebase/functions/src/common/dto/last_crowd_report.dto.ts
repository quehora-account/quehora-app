export class LastCrowdReportDto {
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

  static fromJson(json: any | null): LastCrowdReportDto | null {
    if (json == null) {
      return null;
    }

    const dto = new LastCrowdReportDto({
      createdAt: new Date(json.createdAt),
      userId: json.userId,
      duration: json.duration,
      intensity: json.intensity,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): LastCrowdReportDto[] {
    const list: LastCrowdReportDto[] = [];
    for (const json of jsons) {
      const elem = LastCrowdReportDto.fromJson(json);
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

  static toJsons(reports : LastCrowdReportDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
