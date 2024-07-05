import {HoursEntity} from "./hours.entity";

export class OpenHoursEntity {
  hours : HoursEntity[];

  constructor({hours} : {
          hours: HoursEntity[],

      }) {
    this.hours = hours;
  }

  static fromJson(json: any): OpenHoursEntity {
    const entity = new OpenHoursEntity({
      hours: HoursEntity.fromJsons(json.hours),
    });
    return entity;
  }

  static fromJsons(jsons: any[]): OpenHoursEntity[] {
    const list: OpenHoursEntity[] = [];
    for (const json of jsons) {
      const elem = OpenHoursEntity.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "hours": HoursEntity.toJsons(this.hours),
    };
  }

  static toJsons(reports : OpenHoursEntity[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
