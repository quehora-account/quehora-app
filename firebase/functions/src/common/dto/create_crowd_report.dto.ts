export class CreateCrowdReportDto {
  spotId: string;
  duration: string;
  intensity: number;

  constructor({spotId, duration, intensity} : {
          spotId: string,
          duration: string,
          intensity: number,

      }) {
    this.spotId = spotId;
    this.duration = duration;
    this.intensity = intensity;
  }

  static fromJson(json: any): CreateCrowdReportDto {
    const dto = new CreateCrowdReportDto({
      spotId: json.spotId,
      duration: json.duration,
      intensity: Number(json.intensity),
    });
    return dto;
  }
}
