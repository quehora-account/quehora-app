import {DocumentData} from "firebase-admin/firestore";

export enum ChallengeStatus {
  unlocked = "unlocked",
  claimed = "claimed",
}

export class UnlockedChallengeEntity {
  id: string;
  challengeId: string;
  userId: string;
  gem: number;
  status: ChallengeStatus;

  constructor({id, challengeId, userId, status, gem} : {
          id: string,
          challengeId: string,
          userId: string,
          gem: number,
          status: ChallengeStatus,
        }) {
    this.id = id;
    this.challengeId = challengeId;
    this.userId = userId;
    this.status = status;
    this.gem = gem;
  }

  static fromSnapshot(snapshot: DocumentData): UnlockedChallengeEntity {
    const json = snapshot.data();
    const dto = new UnlockedChallengeEntity({
      id: snapshot.id,
      challengeId: json.challengeId,
      userId: json.userId,
      status: json.status,
      gem: json.gem,
    });
    return dto;
  }

  static fromSnapshots(snapshots: DocumentData[]): UnlockedChallengeEntity[] {
    const list: UnlockedChallengeEntity[] = [];
    for (const snapshot of snapshots) {
      const elem = UnlockedChallengeEntity.fromSnapshot(snapshot);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }
}
