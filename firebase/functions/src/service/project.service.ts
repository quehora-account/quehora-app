import {CreateProjectDto} from "../common/dto/create_project.dto";
import {DonateDto} from "../common/dto/donate_offer.dto";
import {TransactionType} from "../common/entity/transaction.entity";
import {ProjectRepository} from "../repository/project.repository";
import {TransactionRepository} from "../repository/transaction.repository";
import {UserRepository} from "../repository/user.repository";

export class ProjectService {
  static async create(dto: CreateProjectDto) {
    await ProjectRepository.create(dto.toJson());
  }

  static async donate(userId: string, dto: DonateDto) {
    // Create donation document
    await ProjectRepository.createDonation({
      userId: userId,
      projectId: dto.projectId,
      gem: dto.gem,
      createdAt: new Date(),
    });

    // Update project "collected"
    const project = await ProjectRepository.getProjectById(dto.projectId);
    await ProjectRepository.updateCollectedGem(
      project.id,
      project.collected + dto.gem,
    );
    console.log("gere");

    // Update user
    const user = await UserRepository.getUser(userId);
    await UserRepository.updateUserAfterDonation(
      user.id,
      user.gem - dto.gem,
      user.amountDonation + 1,
    );

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.donation,
      "gem": dto.gem,
      "userId": user.userId,
      "name": project.title,
      "createdAt": new Date(),
    });
  }
}
