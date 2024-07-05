import * as gcloud from "@google-cloud/firestore";
import {CreateCityDto} from "./create_city.dto";


export class CreateRegionDto {
  name: string;
  coordinates: gcloud.GeoPoint;
  cities: CreateCityDto[];

  constructor({name, coordinates, cities} : {
          name: string,
          coordinates: gcloud.GeoPoint,
          cities: CreateCityDto[],

      }) {
    this.name = name;
    this.coordinates = coordinates;
    this.cities = cities;
  }

  static fromJson(json: any): CreateRegionDto {
    const dto = new CreateRegionDto({
      name: json.name,
      coordinates: new gcloud.GeoPoint(json.coordinates[0],
        json.coordinates[1]),
      cities: CreateCityDto.fromJsons(json.cities),
    });
    return dto;
  }

  static fromJsons(jsons: any[]): CreateRegionDto[] {
    const list: CreateRegionDto[] = [];
    for (const json of jsons) {
      const elem = CreateRegionDto.fromJson(json);
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
      "cities": CreateCityDto.toJsons( this.cities),
    };
  }
}
