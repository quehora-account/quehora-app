import {HoursDto} from "./hours.dto";

export class OpenHoursDto {
  hours : HoursDto[];

  constructor({hours} : {
          hours: HoursDto[],

      }) {
    this.hours = hours;
  }

  static fromJson(json: any): OpenHoursDto {
    const dto = new OpenHoursDto({
      hours: HoursDto.fromJsons(json.hours),
    });
    return dto;
  }

  static fromJsons(jsons: any[]): OpenHoursDto[] {
    const list: OpenHoursDto[] = [];
    for (const json of jsons) {
      const elem = OpenHoursDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "hours": HoursDto.toJsons(this.hours),
    };
  }

  static toJsons(reports : OpenHoursDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
