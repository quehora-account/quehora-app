import {CreateLevelDto} from "../common/dto/create_level.dto";
import {LevelRepository} from "../repository/level.repository";

export class LevelService {
  static async create(dto: CreateLevelDto) {
    await LevelRepository.create(dto.toJson());
  }
}
