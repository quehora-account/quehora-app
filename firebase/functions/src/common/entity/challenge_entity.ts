import {DocumentData} from "firebase-admin/firestore";

export class ChallengeEntity {
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
    this.from = from;
    this.to = to;
    this.imagePath = imagePath;
    this.priority = priority;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
    this.description = description;
    this.gem = gem;
  }

  static fromSnapshot(snapshot: DocumentData): ChallengeEntity {
    const json = snapshot.data();
    const dto = new ChallengeEntity({
      id: snapshot.id,
      name: json.name,
      from: json.from.toDate(),
      to: json.to == null ? null : json.to.toDate(),
      imagePath: json.imagePath,
      priority: json.priority,
      backgroundColor: json.backgroundColor,
      textColor: json.textColor,
      description: json.description,
      gem: json.gem,
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): ChallengeEntity[] {
    const list: ChallengeEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = ChallengeEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
