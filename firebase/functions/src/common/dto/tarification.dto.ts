
export class TarificationDto {
  price: string;
  condition: string;

  constructor({price, condition} : {
    price: string,
    condition: string,


      }) {
    this.price = price;
    this.condition = condition;
  }

  static fromJson(json: any | null): TarificationDto | null {
    if (json == null) {
      return null;
    }

    const dto = new TarificationDto({
      price: json.price,
      condition: json.condition,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): TarificationDto[] {
    const list: TarificationDto[] = [];
    for (const json of jsons) {
      const elem = TarificationDto.fromJson(json);
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
