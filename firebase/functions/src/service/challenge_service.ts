import * as admin from "firebase-admin";
import {CreateChallengeDto} from "../common/dto/create_challenge.dto";
import {ChallengeStatus, UnlockedChallengeEntity} from "../common/entity/unlocked_challenge.entity";
import {UserEntity} from "../common/entity/user.entity";
import {ChallengeEntity} from "../common/entity/challenge_entity";
import {TransactionRepository} from "../repository/transaction.repository";
import {TransactionType} from "../common/entity/transaction.entity";
import {ChallengeRepository} from "../repository/challenge_repository";
import {SpotRepository} from "../repository/spot.repository";
import {UserRepository} from "../repository/user.repository";
import {ProjectRepository} from "../repository/project.repository";

export class ChallengeService {
  static async create(dto: CreateChallengeDto) : Promise<void> {
    await admin.firestore().collection("challenge").doc(dto.id).set(dto.toJson());
  }

  static async createUnlocked(userId: string, challengeId: string) : Promise<void> {
    // Get challenge
    const snapshotChallenge = await admin.firestore().collection("challenge")
      .doc(challengeId)
      .get();
    const challenge = ChallengeEntity.fromSnapshot(snapshotChallenge);

    // Create unlocked challenge with challenge gems
    await admin.firestore().collection("unlockedChallenge").add({
      challengeId: challengeId,
      userId: userId,
      gem: challenge.gem,
      status: ChallengeStatus.unlocked,
    });

    //  Update the user
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.amountChallengeUnlocked += 1;
    await admin.firestore().collection("user").doc(user.id).update({
      amountChallengeUnlocked: user.amountChallengeUnlocked,
    });
  }

  static async claimUnlocked(userId: string, unlockedChallengeId: string) : Promise<void> {
    // Update the unlocked challenge status
    await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).update({
      status: ChallengeStatus.claimed,
    });

    // Get the unlocked challenge
    const unlockedChallengeSnapshot = await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).get();
    const unlockedChallenge = UnlockedChallengeEntity.fromSnapshot(unlockedChallengeSnapshot);

    // Get the unlocked challenge
    const challenge = await ChallengeRepository.getChallengeById(unlockedChallenge.challengeId);

    //  Update the user gem and experience
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.gem += unlockedChallenge.gem;
    user.experience += unlockedChallenge.gem;
    await admin.firestore().collection("user").doc(user.id).update({
      gem: user.gem,
      experience: user.experience,
    });

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.challenge,
      "gem": unlockedChallenge.gem,
      "userId": user.userId,
      "name": challenge.name,
      "createdAt": new Date(),
    });
  }


  /**
   * Trigger challenges verification
   */
  static async trigger(userId:string, challengeIds: string[]) {
    for (const challengeId of challengeIds) {
      switch (challengeId) {
      case "1":
        await ChallengeService._challenge1(userId);
        break;
      case "2":
        await ChallengeService._challenge2(userId);
        break;
      case "3":
        await ChallengeService._challenge3(userId);
        break;
      case "4":
        await ChallengeService._challenge4(userId);
        break;
      case "5":
        await ChallengeService._challenge5();
        break;
      case "6":
        await ChallengeService._challenge6();
        break;
      case "7":
        await ChallengeService._challenge7(userId);
        break;

      case "8":
        await ChallengeService._challenge8(userId);
        break;

      case "9":
        await ChallengeService._challenge9(userId);
        break;

      case "10":
        await ChallengeService._challenge10(userId);
        break;

      case "11":
        await ChallengeService._challenge11(userId);
        break;

      case "12":
        await ChallengeService._challenge12(userId);
        break;

      case "13":
        await ChallengeService._challenge13(userId);
        break;
      }
    }
  }


  /**
  *
  * @param userId
  * @returns
  */
  static async _challenge1(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_1");
      if (isUnlocked) {
        return;
      }

      // Get spots validated
      const spotsValidated = await SpotRepository.getSpotsValidated(userId);

      for (const spotValidated of spotsValidated) {
        // UTC to french
        const createdAt = spotValidated.createdAt;
        createdAt.setHours(createdAt.getHours() + 2);

        if (createdAt.getHours() < 11) {
          ChallengeService.createUnlocked(userId, "challenge_1");
          break;
        }
      }
    } catch (e) {
      // Log error
    }
  }


  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge2(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_2");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountSpotValidated >= 20) {
        ChallengeService.createUnlocked(userId, "challenge_2");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge3(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_3");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountSpotValidated >= 10) {
        ChallengeService.createUnlocked(userId, "challenge_3");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
     *
     * @param userId
     * @returns
     */
  static async _challenge4(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_4");
      if (isUnlocked) {
        return;
      }

      // Get spots validated
      const spotsValidated = await SpotRepository.getSpotsValidated(userId);

      for (const spotValidated of spotsValidated) {
        // UTC to french
        const createdAt = spotValidated.createdAt;
        createdAt.setHours(createdAt.getHours() + 2);

        if (createdAt.getHours() >= 19) {
          ChallengeService.createUnlocked(userId, "challenge_4");
          break;
        }
      }
    } catch (e) {
      // Log error
    }
  }


  static async _challenge5() : Promise<void> {
    try {
      // Fetch all users
      const users = await UserRepository.getAll();

      // Sort users based on experience
      users.sort( (a, b) => {
        return a.experience > b.experience ? -1 : 1;
      });

      // Defining tops as list
      const top = users.slice(0, 3);

      for (const user of users) {
        // Already unlocked
        const isUnlocked = await ChallengeRepository.isUnlocked(user.userId, "challenge_5");
        if (isUnlocked) {
          continue;
        }

        for (const topUser of top) {
          if (user.userId === topUser.userId) {
            await ChallengeService.createUnlocked(user.userId, "challenge_5");
          }
        }
      }
    } catch (e) {
      // Log error
    }
  }

  static async _challenge6() : Promise<void> {
    try {
      // Fetch all users
      const users = await UserRepository.getAll();

      // Sort users based on experience
      users.sort( (a, b) => {
        return a.experience > b.experience ? -1 : 1;
      });

      // Defining tops as list
      const top = users.slice(0, 10);

      for (const user of users) {
        // Already unlocked
        const isUnlocked = await ChallengeRepository.isUnlocked(user.userId, "challenge_6");
        if (isUnlocked) {
          continue;
        }

        for (const topUser of top) {
          if (user.userId === topUser.userId) {
            await ChallengeService.createUnlocked(user.userId, "challenge_6");
          }
        }
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge7(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_7");
      if (isUnlocked) {
        return;
      }

      // Fetch donations
      const donations = await ProjectRepository.getDonations(userId);

      if (donations.length > 0) {
        ChallengeService.createUnlocked(userId, "challenge_7");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge8(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_8");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountSpotValidated >= 50) {
        ChallengeService.createUnlocked(userId, "challenge_8");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge9(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_9");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountSpotValidated >= 100) {
        ChallengeService.createUnlocked(userId, "challenge_9");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge10(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_10");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountCrowdReportCreated >= 10) {
        ChallengeService.createUnlocked(userId, "challenge_10");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge11(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_11");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountCrowdReportCreated >= 20) {
        ChallengeService.createUnlocked(userId, "challenge_11");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge12(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_12");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountCrowdReportCreated >= 50) {
        ChallengeService.createUnlocked(userId, "challenge_12");
      }
    } catch (e) {
      // Log error
    }
  }

  /**
   *
   * @param userId
   * @returns
   */
  static async _challenge13(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_13");
      if (isUnlocked) {
        return;
      }

      const user = await UserRepository.getUser(userId);

      if (user.amountCrowdReportCreated >= 100) {
        ChallengeService.createUnlocked(userId, "challenge_13");
      }
    } catch (e) {
      // Log error
    }
  }
}
