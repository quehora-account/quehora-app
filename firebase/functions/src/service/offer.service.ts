import {CreateOfferDto} from "../common/dto/create_offer.dto";
import {TransactionType} from "../common/entity/transaction.entity";
import {UnlockedOfferStatus} from "../common/entity/unlocked_offer.entity";
import {CompanyRepository} from "../repository/company.repository";
import {OfferRepository} from "../repository/offer.repository";
import {TransactionRepository} from "../repository/transaction.repository";
import {UserRepository} from "../repository/user.repository";

export class OfferService {
  static async create(dto: CreateOfferDto) {
    await OfferRepository.create(dto.toJson());
  }

  static async unlock(userId: string, offerId: string) {
    const offer = await OfferRepository.getById(offerId);

    // Extract code
    const code = offer.codes[0];

    // Remove code from offer
    offer.codes.shift();

    // Create unlocked offer
    await OfferRepository.createUnlockOffer({
      userId: userId,
      offerId: offer.id,
      gem: offer.price,
      code: code,
      status: UnlockedOfferStatus.unlocked,
      createdAt: new Date(),
      validatedAt: null,
    });


    // Update offer codes
    await OfferRepository.updateCodes(offerId, offer.codes);

    // Update user
    const user = await UserRepository.getUser(userId);
    await UserRepository.updateUserAfterUnlockingOffer(
      user.id,
      user.gem - offer.price,
      user.amountOfferUnlocked + 1,
    );

    // Get company
    const company = await CompanyRepository.getById(offer.companyId);

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.offer,
      "gem": offer.price,
      "userId": user.userId,
      "name": company.name,
      "createdAt": new Date(),
    });
  }
}
