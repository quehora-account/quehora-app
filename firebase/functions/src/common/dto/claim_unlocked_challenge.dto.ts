export class ClaimUnlockedChallengeDto {
  unlockedChallengeId: string;

  constructor({unlockedChallengeId} : {
        unlockedChallengeId: string,
      }) {
    this.unlockedChallengeId = unlockedChallengeId;
  }

  static fromJson(json: any): ClaimUnlockedChallengeDto {
    const dto = new ClaimUnlockedChallengeDto({
      unlockedChallengeId: json.unlockedChallengeId,
    });
    return dto;
  }

  toJson() : object {
    return {
      "unlockedChallengeId": this.unlockedChallengeId,
    };
  }
}
