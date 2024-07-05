export class CreateLevelDto {
  level: number;
  title: string;
  experienceRequired: number;
  imagePath: string;
  blankImagePath: string;
  displayedLevel: string;

  constructor({level, title, experienceRequired, imagePath, blankImagePath, displayedLevel} : {
      level: number,
      title: string,
      experienceRequired: number,
      imagePath: string,
      blankImagePath: string,
      displayedLevel: string,
    }) {
    this.level = level;
    this.title = title;
    this.experienceRequired = experienceRequired;
    this.imagePath = imagePath;
    this.blankImagePath = blankImagePath;
    this.displayedLevel = displayedLevel;
  }

  static fromJson(json: any): CreateLevelDto {
    const dto = new CreateLevelDto({
      level: json.level,
      title: json.title,
      experienceRequired: json.experienceRequired,
      imagePath: json.imagePath,
      blankImagePath: json.blankImagePath,
      displayedLevel: json.displayedLevel,
    });
    return dto;
  }

  toJson() : object {
    return {
      "level": this.level,
      "title": this.title,
      "experienceRequired": this.experienceRequired,
      "imagePath": this.imagePath,
      "blankImagePath": this.blankImagePath,
      "displayedLevel": this.displayedLevel,
    };
  }
}
