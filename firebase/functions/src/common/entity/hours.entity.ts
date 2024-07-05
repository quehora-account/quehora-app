export class HoursEntity {
  start: string;
  end: string;

  constructor({start, end} : {
          start: string,
          end: string,

      }) {
    this.start = start;
    this.end = end;
  }

  static fromJson(json: any): HoursEntity {
    const dto = new HoursEntity({
      start: json.start,
      end: json.end,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): HoursEntity[] {
    const list: HoursEntity[] = [];
    for (const json of jsons) {
      const elem = HoursEntity.fromJson(json);
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

  static toJsons(reports : HoursEntity[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
