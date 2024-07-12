import * as gcloud from "@google-cloud/firestore";

export class ValidateSpotDto {
    coordinates: gcloud.GeoPoint; // Ajout du champ coordinates

    constructor({ coordinates }: {
        coordinates: gcloud.GeoPoint // Ajout du champ coordinates
    }) {
        this.coordinates = coordinates; // Initialisation du champ coordinates
    }

    static fromJson(json: any): ValidateSpotDto {
        const coordinatesArray = JSON.parse(json.coordinates); // Convertir la chaîne en liste de coordonnées

        const dto = new ValidateSpotDto({
            coordinates: new gcloud.GeoPoint(coordinatesArray[0], coordinatesArray[1]) // Conversion de json en GeoPoint
        });
        return dto;
    }
}
