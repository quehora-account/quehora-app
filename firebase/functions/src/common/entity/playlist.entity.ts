import {DocumentData} from "firebase-admin/firestore";

export class PlaylistEntity {
  id: string;
  name: string;
  imagePath: string;
  priority: number;

  constructor({id, name, imagePath, priority} : {
          id: string,
          name: string,
          imagePath: string,
          priority: number,
        }) {
    this.id = id;
    this.name = name;
    this.imagePath = imagePath;
    this.priority = priority;
  }

  static fromSnapshot(snapshot: DocumentData): PlaylistEntity {
    const json = snapshot.data();
    const dto = new PlaylistEntity({
      id: snapshot.id,
      name: json.name,
      imagePath: json.imagePath,
      priority: json.priority,
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): PlaylistEntity[] {
    const list: PlaylistEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = PlaylistEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
