import {HoursEntity} from "./hours.entity";

export class ExceptionalOpenHoursEntity {
  date: Date;
  hours: HoursEntity[];

  constructor({date, hours} : {
      date: Date;
    hours: HoursEntity[];
    }) {
    this.date = date;
    this.hours = hours;
  }

  static fromJson(json: any): ExceptionalOpenHoursEntity {
    const entity = new ExceptionalOpenHoursEntity({
      date: json.date.toDate(),
      hours: HoursEntity.fromJsons(json.hours),
    });
    return entity;
  }

  static fromJsons(jsons: any[]): ExceptionalOpenHoursEntity[] {
    const list: ExceptionalOpenHoursEntity[] = [];
    for (const json of jsons) {
      const elem = ExceptionalOpenHoursEntity.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "date": this.date,
      "hours": HoursEntity.toJsons(this.hours),
    };
  }

  static toJsons(reports : ExceptionalOpenHoursEntity[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
