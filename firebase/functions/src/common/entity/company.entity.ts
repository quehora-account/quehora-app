import {DocumentData} from "firebase-admin/firestore";

export class CompanyEntity {
  id: string;
  name: string;
  imagePath: string;
  cityId: number;

  constructor({id, name, imagePath, cityId} : {
          id: string,
          name: string,
          imagePath: string,
          cityId: number,
        }) {
    this.id = id;
    this.name = name;
    this.imagePath = imagePath;
    this.cityId = cityId;
  }

  static fromSnapshot(snapshot: DocumentData): CompanyEntity {
    const json = snapshot.data();
    const dto = new CompanyEntity({
      id: snapshot.id,
      name: json.name,
      imagePath: json.imagePath,
      cityId: json.cityId,
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): CompanyEntity[] {
    const list: CompanyEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = CompanyEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
