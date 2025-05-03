import {CreateSpotDto} from "../common/dto/create_spot.dto";
import {ValidateSpotDto } from "../common/dto/validation_spot.dto";
import {TransactionType} from "../common/entity/transaction.entity";
import {SpotRepository} from "../repository/spot.repository";
import {TransactionRepository} from "../repository/transaction.repository";
import {UserRepository} from "../repository/user.repository";

export class SpotService {
  static trafficPoints: number[][] = [
    [30, 30, 25, 20, 15, 10, -10, -15],
    [30, 25, 20, 15, 10, -10, -15, -20],
    [25, 20, 15, 10, -10, -15, -20, -25],
    [20, 15, 10, -10, -15, -20, -25, -30],
    [15, 10, -10, -15, -20, -25, -30, -30],
];


  static _getTrafficPoint2(density: number, popularTime : number, average: number) : number {
    if (popularTime === 0) {
      return 0;
    }

    const difference: number = average - popularTime;
    if (difference <= -30) {
      return this.trafficPoints[density - 1][7];
    }
    if (difference <= -20) {
      return this.trafficPoints[density - 1][6];
    }
    if (difference <= -10) {
      return this.trafficPoints[density - 1][5];
    }
    if (difference <= 0) {
      return this.trafficPoints[density - 1][4];
    }
    if (difference <= 10) {
      return this.trafficPoints[density - 1][3];
    }
    if (difference <= 20) {
      return this.trafficPoints[density - 1][2];
    }

    if (difference <= 30) {
      return this.trafficPoints[density - 1][1];
    }
    return this.trafficPoints[density - 1][0];
  }

  /**
   * Generate traffic points
   */
  static generateTrafficPoints(popularTimes: Map<string, number>[], density: number): object[] {
    // Set average
    let average = 0;
    let total = 0;
    for (const popularTime of popularTimes) {
      for (const [_, value] of Object.entries(popularTime)) {
        if (value > 0) {
          total += 1;
          average += value;
        }
      }
    }
    average = average / total;

    // Generate gemPerDays
    const trafficPoints: Map<string, number>[] = [];

    for (const popularTime of popularTimes) {
      const gpd = new Map<string, number>();

      for (const [key, value] of Object.entries(popularTime)) {
        gpd.set(key, this._getTrafficPoint2(density, value, average));
      }

      trafficPoints.push(gpd);
    }


    return trafficPoints.map((e) => Object.fromEntries(e));
  }

  static async create(dto: CreateSpotDto) {
    await SpotRepository.create({
      ...dto.toJson(),
    });
  }

  static async validate(userId: string, spotId: string, dto: ValidateSpotDto) {
    const spot = await SpotRepository.getSpotById(spotId);
    const gems = spot.getGemsNow();

    //  Create a new validation document
    await SpotRepository.createSpotValidation({
      userId: userId,
      spotId: spotId,
      gems: gems,
      createdAt: new Date(Date.now()),
      coordinates: dto.coordinates
    });

    //  Update the user
    const user = await UserRepository.getUser(userId);
    await UserRepository.updateUserAftervalidatingSpot(
      user.id,
      user.gem + gems,
      user.experience + gems,
      user.amountSpotValidated + 1,
    );

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.validation,
      "gem": gems,
      "userId": userId,
      "name": spot.name,
      "createdAt": new Date(),
    });
  }
}
