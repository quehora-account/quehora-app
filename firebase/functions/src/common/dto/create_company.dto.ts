export class CreateCompanyDto {
  name: string;
  imagePath: string;
  cityId: string;

  constructor({name, imagePath, cityId} : {
        name: string,
        imagePath: string,
        cityId: string,
      }) {
    this.name = name;
    this.imagePath = imagePath;
    this.cityId = cityId;
  }

  static fromJson(json: any): CreateCompanyDto {
    const dto = new CreateCompanyDto({
      name: json.name,
      imagePath: json.imagePath,
      cityId: json.cityId,
    });
    return dto;
  }

  toJson() : object {
    return {
      "name": this.name,
      "imagePath": this.imagePath,
      "cityId": this.cityId,
    };
  }
}
