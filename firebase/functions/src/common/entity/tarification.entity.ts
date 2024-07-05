
export class TarificationEntity {
  price: string;
  condition: string;

  constructor({price, condition} : {
      price: string,
      condition: string,


        }) {
    this.price = price;
    this.condition = condition;
  }

  static fromJson(json: any | null): TarificationEntity | null {
    if (json == null) {
      return null;
    }

    const dto = new TarificationEntity({
      price: json.price,
      condition: json.condition,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): TarificationEntity[] {
    const list: TarificationEntity[] = [];
    for (const json of jsons) {
      const elem = TarificationEntity.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "price": this.price,
      "condition": this.condition,
    };
  }
}
