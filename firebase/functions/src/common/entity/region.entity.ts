import * as gcloud from "@google-cloud/firestore";
import {CityEntity} from "./city.entity";
import {DocumentData} from "firebase-admin/firestore";


export class RegionEntity {
  id: string;
  name: string;
  coordinates: gcloud.GeoPoint;
  cities: CityEntity[];

  constructor({id, name, coordinates, cities} : {
          id: string,
          name: string,
          coordinates: gcloud.GeoPoint,
          cities: CityEntity[],

      }) {
    this.id = id;
    this.name = name;
    this.coordinates = coordinates;
    this.cities = cities;
  }

  static fromSnapshot(snapshot: DocumentData): RegionEntity {
    const json = snapshot.data();
    const entity = new RegionEntity({
      id: snapshot.id,
      name: json.name,
      coordinates: json.coordinates,
      cities: CityEntity.fromJsons(json.cities),
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): RegionEntity[] {
    const list: RegionEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = RegionEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
