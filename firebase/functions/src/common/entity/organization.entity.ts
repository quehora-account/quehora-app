import {DocumentData} from "firebase-admin/firestore";

export class OrganizationEntity {
  id: string;
  name: string;
  imagePath: string;

  constructor({id, name, imagePath} : {
          id: string,
          name: string,
          imagePath: string,
        }) {
    this.id = id;
    this.name = name;
    this.imagePath = imagePath;
  }

  static fromSnapshot(snapshot: DocumentData): OrganizationEntity {
    const json = snapshot.data();
    const dto = new OrganizationEntity({
      id: snapshot.id,
      name: json.name,
      imagePath: json.imagePath,
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): OrganizationEntity[] {
    const list: OrganizationEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = OrganizationEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
