export class CreatePlaylistDto {
  name: string;
  imagePath: string;
  priority: number;

  constructor({name, imagePath, priority} : {
        name: string,
        imagePath: string,
        priority: number,
      }) {
    this.name = name;
    this.imagePath = imagePath;
    this.priority = priority;
  }

  static fromJson(json: any): CreatePlaylistDto {
    const dto = new CreatePlaylistDto({
      name: json.name,
      imagePath: json.imagePath,
      priority: json.priority,
    });
    return dto;
  }

  toJson() : object {
    return {
      "name": this.name,
      "imagePath": this.imagePath,
      "priority": this.priority,
    };
  }
}
