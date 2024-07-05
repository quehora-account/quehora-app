import {HoursDto} from "./hours.dto";

export class ExceptionalOpenHoursDto {
  date: Date;
  hours: HoursDto[];

  constructor({date, hours} : {
      date: Date;
    hours: HoursDto[];
    }) {
    this.date = date;
    this.hours = hours;
  }

  static fromJson(json: any): ExceptionalOpenHoursDto {
    const dto = new ExceptionalOpenHoursDto({
      date: new Date(json.date),
      hours: HoursDto.fromJsons(json.hours),
    });
    return dto;
  }

  static fromJsons(jsons: any[]): ExceptionalOpenHoursDto[] {
    const list: ExceptionalOpenHoursDto[] = [];
    for (const json of jsons) {
      const elem = ExceptionalOpenHoursDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "date": this.date,
      "hours": HoursDto.toJsons(this.hours),
    };
  }

  static toJsons(reports : ExceptionalOpenHoursDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
