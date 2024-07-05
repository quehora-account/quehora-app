import {CreateRegionDto} from "../common/dto/create_region.dto";
import {CityEntity} from "../common/entity/city.entity";
import {RegionEntity} from "../common/entity/region.entity";
import * as admin from "firebase-admin";

export class RegionService {
  static async create(dto: CreateRegionDto) {
    await admin.firestore().collection("region").add(dto.toJson());
  }

  static async increaseSpotQuantity(regionId : string, cityId: string) {
    // Retrieve region
    const regionSnapshot = await admin.firestore().collection("region").doc(regionId).get();
    const region = RegionEntity.fromSnapshot(regionSnapshot);

    // Increment the right region spot quantity
    const cities = region.cities;
    for (const city of cities) {
      if (city.id === cityId) {
        city.spotQuantity += 1;
        break;
      }
    }

    // Update spot quantity
    await admin.firestore().collection("region").doc(regionId).update({
      cities: CityEntity.toJsons(cities),
    });
  }

  static async decreaseSpotQuantity(regionId : string, cityId: string) {
    // Retrieve region
    const regionSnapshot = await admin.firestore().collection("region").doc(regionId).get();
    const region = RegionEntity.fromSnapshot(regionSnapshot);

    // Decrease the right region spot quantity
    const cities = region.cities;
    for (const city of cities) {
      if (city.id === cityId) {
        city.spotQuantity -= 1;
        break;
      }
    }

    // Update spot quantity
    await admin.firestore().collection("region").doc(regionId).update({
      cities: CityEntity.toJsons(cities),
    });
  }
}
