export class CreateOrganizationDto {
  name: string;
  imagePath: string;


  constructor({name, imagePath} : {
        name: string,
        imagePath: string,
      }) {
    this.name = name;
    this.imagePath = imagePath;
  }

  static fromJson(json: any): CreateOrganizationDto {
    const dto = new CreateOrganizationDto({
      name: json.name,
      imagePath: json.imagePath,
    });
    return dto;
  }

  toJson() : object {
    return {
      "name": this.name,
      "imagePath": this.imagePath,
    };
  }
}
