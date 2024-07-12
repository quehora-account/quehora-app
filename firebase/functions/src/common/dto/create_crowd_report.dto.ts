import * as gcloud from "@google-cloud/firestore";

export class CreateCrowdReportDto {
  spotId: string;
  duration: string;
  intensity: number;
  coordinates: gcloud.GeoPoint; // Ajout du champ coordinates

  constructor({ spotId, duration, intensity, coordinates }: {
          spotId: string,
          duration: string,
          intensity: number,
    coordinates: gcloud.GeoPoint // Ajout du champ coordinates
      }) {
    this.spotId = spotId;
    this.duration = duration;
    this.intensity = intensity;
    this.coordinates = coordinates; // Initialisation du champ coordinates
  }

  static fromJson(json: any): CreateCrowdReportDto {
    const coordinatesArray = JSON.parse(json.coordinates); // Convertir la chaîne en liste de coordonnées

    const dto = new CreateCrowdReportDto({
      spotId: json.spotId,
      duration: json.duration,
      intensity: Number(json.intensity),
      coordinates: new gcloud.GeoPoint(coordinatesArray[0], coordinatesArray[1]) // Conversion de json en GeoPoint
    });
    return dto;
  }
}
