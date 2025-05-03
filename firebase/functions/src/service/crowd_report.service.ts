import {CreateCrowdReportDto} from "../common/dto/create_crowd_report.dto";
import {CrowdReportRepository} from "../repository/crowd_report.repository";
import {SpotRepository} from "../repository/spot.repository";

import {UserRepository} from "../repository/user.repository";
import {TransactionRepository} from "../repository/transaction.repository";
import {LastCrowdReportEntity} from "../common/entity/last_crowd_report.entity";
import {TransactionType} from "../common/entity/transaction.entity";

export class CrowdReportService {
  static async create(dto: CreateCrowdReportDto, userId: string) {
    // Create crowd report document
    await CrowdReportRepository.create({
      userId: userId,
      spotId: dto.spotId,
      intensity: dto.intensity,
      duration: dto.duration,
      createdAt: new Date(),
      coordinates: dto.coordinates,
    });
    

    // Get the spot
    var spot = await SpotRepository.getSpotById(dto.spotId);

    // Update the last crowd report
    var newReport = new LastCrowdReportEntity({
      createdAt: new Date(),
      duration: dto.duration,
      intensity: dto.intensity,
      userId: userId,
      coordinates: dto.coordinates,
    });
    // Update the all crowd reports
    var today = new Date();
    var list = spot.allCrowdReports;
    if(spot.allCrowdReports.length>0){
      for (var i = list.length - 1; i >= 0; i--) {
        var report = list[i];
        console.info("today.getDay()" + today.toUTCString());
        console.info("report.createdAt.getDay()" + report.createdAt.getUTCDay());
    
        if(report.createdAt.getMonth() !== today.getMonth()){
          console.info("splice");
          list.splice(i, 1); // Remove the report from the list
        }else{
          if (report.createdAt.getDay() !== today.getDay()) {
            console.info("splice");
            list.splice(i, 1); // Remove the report from the list
          } else {
            break; // Exit the loop if the report matches
          }
        }
      }
    }
    list.push(newReport);
    await SpotRepository.updateAllCrowdReport(dto.spotId, LastCrowdReportEntity.toJsons(list));
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
