import * as gcloud from "@google-cloud/firestore";


export class CityEntity {
  name: string;
  coordinates: gcloud.GeoPoint;
  spotQuantity: number;
  id: string;

  constructor({name, coordinates, spotQuantity, id} : {
          name: string,
          coordinates: gcloud.GeoPoint,
          spotQuantity: number,
          id: string,

      }) {
    this.name = name;
    this.coordinates = coordinates;
    this.spotQuantity = spotQuantity;
    this.id = id;
  }

  static fromJson(json: any): CityEntity {
    const entity = new CityEntity({
      name: json.name,
      coordinates: json.coordinates,
      spotQuantity: json.spotQuantity,
      id: json.id,
    });
    return entity;
  }

  static fromJsons(jsons: any[]): CityEntity[] {
    const list: CityEntity[] = [];
    for (const json of jsons) {
      const elem = CityEntity.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "name": this.name,
      "coordinates": this.coordinates,
      "spotQuantity": this.spotQuantity,
      "id": this.id,
    };
  }

  static toJsons(reports : CityEntity[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
