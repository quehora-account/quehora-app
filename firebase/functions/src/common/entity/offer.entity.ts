import {DocumentData} from "firebase-admin/firestore";

export enum CodeType {
    reference = "reference",
    single_use = "single_use",
  }

export class OfferEntity {
  id: string;
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

  constructor({id, companyId, imagePath, priority, title, description, instructions, conditions, levelRequired, price, from, to, codes, codeType, cityId} : {
      id: string;
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
    this.id = id;
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

  static fromSnapshot(snapshot: DocumentData): OfferEntity {
    const json = snapshot.data();
    const entity = new OfferEntity({
      id: snapshot.id,
      companyId: json.companyId,
      imagePath: json.imagePath,
      priority: json.priority,
      title: json.title,
      description: json.description,
      instructions: json.instructions,
      conditions: new Map(Object.entries(json.conditions)),
      levelRequired: json.levelRequired,
      price: json.price,
      from: new Date(json.from),
      to: json.to === null ? null : new Date(json.to),
      codes: json.codes,
      codeType: json.codeType,
      cityId: json.cityId,
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): OfferEntity[] {
    const list: OfferEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = OfferEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
