export class HoursDto {
  start: string;
  end: string;

  constructor({start, end} : {
          start: string,
          end: string,

      }) {
    this.start = start;
    this.end = end;
  }

  static fromJson(json: any): HoursDto {
    const dto = new HoursDto({
      start: json.start,
      end: json.end,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): HoursDto[] {
    const list: HoursDto[] = [];
    for (const json of jsons) {
      const elem = HoursDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "start": this.start,
      "end": this.end,
    };
  }

  static toJsons(reports : HoursDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
