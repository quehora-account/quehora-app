import {DocumentData} from "firebase-admin/firestore";

export enum UnlockedOfferStatus {
    unlocked = "unlocked",
    activated = "activated",
  }

export class UnlockedOfferEntity {
  id: string;
  offerId: string;
  userId: string;
  code: string;
  status: UnlockedOfferStatus;
  gem: number;
  createdAt: Date;
  validatedAt: Date | null;


  constructor({id, offerId, userId, status, gem, createdAt, validatedAt, code} : {
      id: string;
      offerId: string;
      userId: string;
      code: string;
      status: UnlockedOfferStatus;
      gem: number;
      createdAt: Date;
      validatedAt: Date | null;
        }) {
    this.id = id;
    this.offerId = offerId;
    this.userId = userId;
    this.status = status;
    this.gem = gem;
    this.createdAt = createdAt;
    this.code = code;
    this.validatedAt = validatedAt;
  }

  static fromSnapshot(snapshot: DocumentData): UnlockedOfferEntity {
    const json = snapshot.data();
    const entity = new UnlockedOfferEntity({
      id: snapshot.id,
      offerId: json.offerId,
      userId: json.userId,
      code: json.code,
      status: json.status,
      gem: json.gem,
      createdAt: json.createdAt,
      validatedAt: json.validated,
    });
    return entity;
  }

  static fromSnapshots(snapshots: DocumentData[]): UnlockedOfferEntity[] {
    const list: UnlockedOfferEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = UnlockedOfferEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
