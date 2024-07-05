
export class CreateProjectDto {
  organizationId: string;
  imagePath: string;
  title: string;
  subtitle: string;
  descriptions: Map<string, string>;
  from: Date;
  to: Date | null;
  collected: number;
  goal: number;
  smallDonation: number;
  mediumDonation: number;
  bigDonation: number;

  constructor({organizationId, imagePath, title, subtitle, descriptions, from, to, collected, goal, smallDonation, mediumDonation, bigDonation} : {
    organizationId: string;
    imagePath: string;
    title: string;
    subtitle: string;
    descriptions:Map<string, string>;
    from: Date;
    to: Date | null;
    collected: number;
    goal: number;
    smallDonation: number;
    mediumDonation: number;
    bigDonation: number;
      }) {
    this.organizationId = organizationId;
    this.imagePath = imagePath;
    this.title = title;
    this.subtitle = subtitle;
    this.descriptions = descriptions;
    this.from = from;
    this.to = to;
    this.collected = collected;
    this.goal = goal;
    this.smallDonation = smallDonation;
    this.mediumDonation = mediumDonation;
    this.bigDonation = bigDonation;
  }

  static fromJson(json: any): CreateProjectDto {
    const dto = new CreateProjectDto({
      organizationId: json.organizationId,
      imagePath: json.imagePath,
      title: json.title,
      subtitle: json.subtitle,
      descriptions: json.descriptions,
      collected: json.collected,
      goal: json.goal,
      smallDonation: json.smallDonation,
      mediumDonation: json.mediumDonation,
      bigDonation: json.bigDonation,
      from: new Date(json.from),
      to: json.to === null ? null : new Date(json.to),

    });
    return dto;
  }

  toJson() : object {
    return {
      "organizationId": this.organizationId,
      "imagePath": this.imagePath,
      "title": this.title,
      "subtitle": this.subtitle,
      "descriptions": this.descriptions,
      "collected": this.collected,
      "goal": this.goal,
      "smallDonation": this.smallDonation,
      "mediumDonation": this.mediumDonation,
      "bigDonation": this.bigDonation,
      "from": this.from,
      "to": this.to,
    };
  }
}
