export class UnlockOfferDto {
  offerId: string;

  constructor({offerId} : {
          offerId: string,

      }) {
    this.offerId = offerId;
  }

  static fromJson(json: any): UnlockOfferDto {
    const dto = new UnlockOfferDto({
      offerId: json.offerId,
    });
    return dto;
  }
}
