export class DonateDto {
  projectId: string;
  gem: number;

  constructor({projectId, gem} : {
          projectId: string,
          gem: number,

      }) {
    this.projectId = projectId;
    this.gem = gem;
  }

  static fromJson(json: any): DonateDto {
    const dto = new DonateDto({
      projectId: json.projectId,
      gem: Number.parseInt(json.gem),
    });
    return dto;
  }
}
