
export class CreateChallengeDto {
  id: string;
  name: string;
  imagePath: string;
  priority: number;
  description: string;
  backgroundColor: number[];
  textColor: number[];
  gem: number;
  from: Date;
  to: Date | null;

  constructor({id, name, imagePath, priority, description, backgroundColor, textColor, gem, from, to} : {
          id: string,
          name: string,
          imagePath: string,
          priority: number,
          description: string;
          backgroundColor: number[];
          textColor: number[];
          gem: number;
          from: Date;
          to: Date | null;
        }) {
    this.id = id;
    this.name = name;
    this.imagePath = imagePath;
    this.priority = priority;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
    this.description = description;
    this.gem = gem;
    this.from = from;
    this.to = to;
  }

  static fromJson(json: any): CreateChallengeDto {
    const dto = new CreateChallengeDto({
      id: json.id,
      name: json.name,
      imagePath: json.imagePath,
      from: new Date(json.from),
      to: json.to === null ? null : new Date(json.to),
      priority: json.priority,
      description: json.description,
      backgroundColor: json.backgroundColor,
      textColor: json.textColor,
      gem: json.gem,
    });
    return dto;
  }

  toJson() : object {
    return {
      "name": this.name,
      "imagePath": this.imagePath,
      "priority": this.priority,
      "gem": this.gem,
      "backgroundColor": this.backgroundColor,
      "textColor": this.textColor,
      "description": this.description,
      "from": this.from,
      "to": this.to,
    };
  }
}
