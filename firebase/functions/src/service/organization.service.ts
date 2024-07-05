import {CreateOrganizationDto} from "../common/dto/create_organization.dto";
import {OrganizationRepository} from "../repository/organization.repository";

export class OrganizationService {
  static async create(dto: CreateOrganizationDto) {
    await OrganizationRepository.create(dto.toJson());
  }
}
