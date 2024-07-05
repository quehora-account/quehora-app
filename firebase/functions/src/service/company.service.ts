import {CreateCompanyDto} from "../common/dto/create_company.dto";
import {CompanyRepository} from "../repository/company.repository";

export class CompanyService {
  static async create(dto: CreateCompanyDto) {
    await CompanyRepository.create(dto.toJson());
  }
}
