import {DocumentData} from "firebase-admin/firestore";

export enum TransactionType {
  validation = "validation",
  crowd_report = "crowd_report",
  launch_gift = "launch_gift",
  challenge = "challenge",
  offer = "offer",
  donation = "donation",
}


export class TransactionEntity {
  id: string;
  userId: string;
  name: string;
  gem: number;
  createdAt: Date;
  type: TransactionType;

  constructor({id, name, userId, gem, createdAt, type} : {
      id: string;
      name: string;
      userId: string;
      gem: number;
      createdAt: Date;
  type: TransactionType;

        }) {
    this.id = id;
    this.name = name;
    this.userId = userId;
    this.gem = gem;
    this.createdAt = createdAt;
    this.type = type;
  }

  static fromSnapshot(snapshot: DocumentData): TransactionEntity {
    const json = snapshot.data();
    const entity = new TransactionEntity({
      id: snapshot.id,
      name: json.name,
      userId: json.userId,
      gem: json.gem,
      createdAt: json.createdAt,
      type: json.type,
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): TransactionEntity[] {
    const list: TransactionEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = TransactionEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
