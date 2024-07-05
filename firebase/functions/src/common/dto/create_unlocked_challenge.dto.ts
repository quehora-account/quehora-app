export class CreateUnlockedChallengeDto {
  userId: string;
  challengeId: string;

  constructor({userId, challengeId} : {
        userId: string,
        challengeId: string,
      }) {
    this.userId = userId;
    this.challengeId = challengeId;
  }

  static fromJson(json: any): CreateUnlockedChallengeDto {
    const dto = new CreateUnlockedChallengeDto({
      userId: json.userId,
      challengeId: json.challengeId,
    });
    return dto;
  }

  toJson() : object {
    return {
      "userId": this.userId,
      "challengeId": this.challengeId,
    };
  }
}
