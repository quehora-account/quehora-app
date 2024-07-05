import * as gcloud from "@google-cloud/firestore";


export class CreateCityDto {
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

  static fromJson(json: any): CreateCityDto {
    const dto = new CreateCityDto({
      name: json.name,
      coordinates: new gcloud.GeoPoint(json.coordinates[0],
        json.coordinates[1]),
      spotQuantity: json.spotQuantity,
      id: json.id,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): CreateCityDto[] {
    const list: CreateCityDto[] = [];
    for (const json of jsons) {
      const elem = CreateCityDto.fromJson(json);
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

  static toJsons(reports : CreateCityDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
