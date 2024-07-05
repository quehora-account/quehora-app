export class BalancePremiumEntity {
  from: Date;
  to: Date;
  gem: number;

  constructor({from, to, gem} : {
      from: Date,
      to: Date,
      gem: number,
    }) {
    this.from = from;
    this.to = to;
    this.gem = gem;
  }

  static fromJson(json: any): BalancePremiumEntity | null {
    if (json == null) {
      return null;
    }

    const entity = new BalancePremiumEntity({
      from: json.from.toDate(),
      to: json.to.toDate(),
      gem: json.gem,
    });
    return entity;
  }

  toJson() : object {
    return {
      "from": this.from,
      "to": this.to,
      "gem": this.gem,
    };
  }
}
