import {CreateCrowdReportDto} from "../common/dto/create_crowd_report.dto";
import {LastCrowdReportEntity} from "../common/entity/last_crowd_report.entity";
import {TransactionType} from "../common/entity/transaction.entity";
import {CrowdReportRepository} from "../repository/crowd_report.repository";
import {SpotRepository} from "../repository/spot.repository";
import {TransactionRepository} from "../repository/transaction.repository";
import {UserRepository} from "../repository/user.repository";

export class CrowdReportService {
  static async create(dto: CreateCrowdReportDto, userId: string) {
    // Create crowd report document
    await CrowdReportRepository.create({
      userId: userId,
      spotId: dto.spotId,
      intensity: dto.intensity,
      duration: dto.duration,
      createdAt: new Date(),
    });

    // Get the spot
    const spot = await SpotRepository.getSpotById(dto.spotId);

    // Update the last crowd report
    spot.lastCrowdReport = new LastCrowdReportEntity({
      createdAt: new Date(),
      duration: dto.duration,
      intensity: dto.intensity,
      userId: userId,
    });
    await SpotRepository.updateLastCrowdReport(dto.spotId, spot.lastCrowdReport.toJson());

    //  Update the user
    const user = await UserRepository.getUser(userId);
    await UserRepository.updateUserAfterCreatingReport(
      user.id,
      user.gem + 5,
      user.experience + 5,
      user.amountCrowdReportCreated + 1,
    );

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.crowd_report,
      "gem": 5,
      "userId": userId,
      "name": spot.name,
      "createdAt": new Date(),
    });
  }
}
