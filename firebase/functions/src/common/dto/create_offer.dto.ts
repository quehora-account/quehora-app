import {CodeType} from "../entity/offer.entity";

export class CreateOfferDto {
  companyId: string;
  imagePath: string;
  priority: number;
  title: string;
  description: string;
  instructions: string[];
  conditions: Map<string, string>;
  levelRequired: number;
  price: number;
  from: Date;
  to: Date | null;
  codes: string[];
  codeType: CodeType;
  cityId: string;

  constructor({companyId, imagePath, priority, title, description, instructions, conditions, levelRequired, price, from, to, codes, codeType, cityId} : {
    companyId: string;
    imagePath: string;
    priority: number;
    title: string;
    description: string;
    instructions: string[];
    conditions: Map<string, string>;
    levelRequired: number;
    price: number;
    from: Date;
    to: Date | null;
    codes: string[];
    codeType: CodeType;
    cityId: string;
      }) {
    this.companyId = companyId;
    this.imagePath = imagePath;
    this.priority = priority;
    this.title = title;
    this.description = description;
    this.instructions = instructions;
    this.conditions = conditions;
    this.levelRequired = levelRequired;
    this.price = price;
    this.from = from;
    this.to = to;
    this.codes = codes;
    this.codeType = codeType;
    this.cityId = cityId;
  }

  static fromJson(json: any): CreateOfferDto {
    const dto = new CreateOfferDto({
      companyId: json.companyId,
      imagePath: json.imagePath,
      priority: json.priority,
      title: json.title,
      description: json.description,
      instructions: json.instructions,
      conditions: json.conditions,
      levelRequired: json.levelRequired,
      price: json.price,
      from: new Date(json.from),
      to: json.to === null ? null : new Date(json.to),
      codes: json.codes,
      codeType: json.codeType,
      cityId: json.cityId,
    });
    return dto;
  }

  toJson() : object {
    return {
      "companyId": this.companyId,
      "imagePath": this.imagePath,
      "priority": this.priority,
      "title": this.title,
      "description": this.description,
      "instructions": this.instructions,
      "conditions": this.conditions,
      "levelRequired": this.levelRequired,
      "price": this.price,
      "from": this.from,
      "to": this.to,
      "codes": this.codes,
      "codeType": this.codeType,
      "cityId": this.cityId,
    };
  }
}
