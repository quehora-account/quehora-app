import * as v1 from "firebase-functions/v1";
import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {CreateSpotDto} from "./common/dto/create_spot.dto";
import {SpotService} from "./service/spot.service";
import {verifyIdToken} from "./common/verify_id_token";
import {CrowdReportService} from "./service/crowd_report.service";
import {CreateCrowdReportDto} from "./common/dto/create_crowd_report.dto";
import {RegionService} from "./service/region.service";
import {CreatePlaylistDto} from "./common/dto/create_playlist.dto";
import {PlaylistService} from "./service/playlist.service";
import {CreateRegionDto} from "./common/dto/create_region.dto";
import {CreateChallengeDto} from "./common/dto/create_challenge.dto";
import {ChallengeService} from "./service/challenge_service";
import {CreateUnlockedChallengeDto} from "./common/dto/create_unlocked_challenge.dto";
import {ClaimUnlockedChallengeDto} from "./common/dto/claim_unlocked_challenge.dto";
import {CreateCompanyDto} from "./common/dto/create_company.dto";
import {CompanyService} from "./service/company.service";
import {CreateOfferDto} from "./common/dto/create_offer.dto";
import {OfferService} from "./service/offer.service";
import {UnlockOfferDto} from "./common/dto/unlock_offer.dto";
import {CreateOrganizationDto} from "./common/dto/create_organization.dto";
import {OrganizationService} from "./service/organization.service";
import {CreateProjectDto} from "./common/dto/create_project.dto";
import {ProjectService} from "./service/project.service";
import {DonateDto} from "./common/dto/donate_offer.dto";
import {TransactionRepository} from "./repository/transaction.repository";
import {TransactionType} from "./common/entity/transaction.entity";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {SpotRepository} from "./repository/spot.repository";
import {CreateLevelDto} from "./common/dto/create_level.dto";
import {LevelService} from "./service/level.service";

// TODO: Upgrade body validation
// TODO: Catch crashes
admin.initializeApp();

/**
 * Create user document, with default values
 */
export const onUserCreated = v1.auth.user().onCreate(async (user) => {
  await admin.firestore().collection("user").add({
    userId: user.uid,
    gem: 15,
    experience: 15,
    firstname: "",
    lastname: "",
    nickname: "",
    city: "",
    country: "",
    gender: null,
    birthday: null,
    amountSpotValidated: 0,
    amountCrowdReportCreated: 0,
    amountChallengeUnlocked: 0,
    amountOfferUnlocked: 0,
    amountDonation: 0,
    createdAt: new Date(),
  });

  // Create transaction
  await TransactionRepository.create({
    "type": TransactionType.launch_gift,
    "gem": 15,
    "userId": user.uid,
    "name": "Récompense de bienvenue",
    "createdAt": new Date(),
  });
});


/**
 * Set traffic points when spot is created
 */
export const onSpotCreated = v2.firestore.onDocumentCreated("spot/{docId}", async (event) => {
  try {
    const data = event.data!.data();
    const popularTimes = data.popularTimes;
    const density = data.density[new Date().getMonth()];
    const trafficPoints = SpotService.generateTrafficPoints(popularTimes, density);
    await SpotRepository.setTrafficPoints(event.data!.id, trafficPoints);
  } catch (e) {
    console.log(e);
  }
});


/**
* Update traffic points when spot is updated if popularTimes or density have changed
*/

function areArraysEqual(arr1: any[], arr2: any[]): boolean {
  if (arr1.length !== arr2.length) {
    return false;
  }
  for (let i = 0; i < arr1.length; i++) {
    if (typeof arr1[i] === "object" && typeof arr2[i] === "object") {
      if (!areObjectsEqual(arr1[i], arr2[i])) {
        return false;
      }
    } else if (arr1[i] !== arr2[i]) {
      return false;
    }
  }
  return true;
}

function areObjectsEqual(obj1: Record<string, any>, obj2: Record<string, any>): boolean {
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);
  if (keys1.length !== keys2.length) {
    return false;
  }
  for (const key of keys1) {
    if (obj1[key] !== obj2[key]) {
      return false;
    }
  }
  return true;
}

export const onSpotUpdated = v2.firestore.onDocumentUpdated("spot/{docId}", async (event) => {
  try {
    const oldPopularTimes: any[] = event.data!.before.data().popularTimes;
    const newPopularTimes: any[] = event.data!.after.data().popularTimes;
    const oldDensity: number[] = event.data!.before.data().density;
    const newDensity: number[] = event.data!.after.data().density;

    v2.logger.info("oldPopularTimes: ", oldPopularTimes, ", newPopularTimes: ", newPopularTimes, ", oldDensity: ", oldDensity, ", newDensity: ", newDensity);

    const popularTimesChanged = !areArraysEqual(oldPopularTimes, newPopularTimes);
    const densityChanged = !areArraysEqual(oldDensity, newDensity);

    if (popularTimesChanged || densityChanged) {
      const popularTimes = newPopularTimes;
      const density = newDensity[new Date().getMonth()];
      const trafficPoints = SpotService.generateTrafficPoints(popularTimes, density);
      await SpotRepository.setTrafficPoints(event.data!.after.id, trafficPoints);
    }
  } catch (e) {
    console.error(e);
  }
});

/**
 * Increase spotQuantity
 */
exports.incrementSpotQuantity = v2.firestore.onDocumentCreated("spot/{docId}", async (event) => {
  const snapshot = event.data;
  if (snapshot == null) {
    return;
  }

  // const spot = SpotEntity.fromSnapshot(snapshot);
  // await RegionService.increaseSpotQuantity(spot);
  const data = snapshot.data();
  await RegionService.increaseSpotQuantity(data.regionId, data.cityId);
});

/**
 * Decrease spotQuantity
 */
exports.decreaseSpotQuantity = v2.firestore.onDocumentDeleted("spot/{docId}", async (event) => {
  const snapshot = event.data;
  if (snapshot == null) {
    return;
  }

  // const spot = SpotEntity.fromSnapshot(snapshot);
  // await RegionService.decreaseSpotQuantity(spot);
  const data = snapshot.data();
  await RegionService.decreaseSpotQuantity(data.regionId, data.cityId);
}
);

/**
 * Triggered every month
 * Used for challenges
 */
exports.everyMonth = onSchedule("0 0 1 * *", async (_: any) => {
  await ChallengeService.trigger("", ["5", "6"]);
});

/**
 * Create spots
 */
export const createSpots = v2.https.onRequest(async (request, response ) => {
  try {
    for (const spot of request.body) {
      const dto = CreateSpotDto.fromJson(spot);
      await SpotService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create playlists
 */
export const createPlaylists = v2.https.onRequest(async (request, response ) => {
  try {
    for (const playlist of request.body) {
      const dto = CreatePlaylistDto.fromJson(playlist);
      await PlaylistService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create regions
 */
export const createRegions = v2.https.onRequest(async (request, response ) => {
  try {
    for (const region of request.body) {
      const dto = CreateRegionDto.fromJson(region);
      await RegionService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


export const debugging = v2.https.onRequest(async (request, response) => {
  try {
    await ChallengeService.trigger("", ["5", "6"]);

    response.json({status: "OK"});
  } catch (e) {
    console.log(e);
    response.json({status: "KO", error: e});
  }
});

/**
 * Validate spot
 */
export const validateSpot = v2.https.onRequest(async (request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const spotId : string = request.body.spotId;

    await SpotService.validate(userId, spotId);

    response.json({status: "OK"});

    ChallengeService.trigger(userId, ["1", "2", "3", "4", "8", "9"]);
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create crowd report
 * Replace last crowd report of attached spot
 */
export const createCrowdReport = v2.https.onRequest(async ( request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = CreateCrowdReportDto.fromJson(request.body);

    await CrowdReportService.create(dto, userId);

    ChallengeService.trigger(userId, ["10", "11", "12", "13"]);

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Unlocked offer
 */
export const unlockOffer = v2.https.onRequest(async ( request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = UnlockOfferDto.fromJson(request.body);

    await OfferService.unlock( userId, dto.offerId);

    // TODO: Implement history

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Donate
 */
export const donate = v2.https.onRequest(async ( request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = DonateDto.fromJson(request.body);

    await ProjectService.donate( userId, dto);

    ChallengeService.trigger(userId, ["7"]);


    response.json({status: "OK"});
  } catch (e) {
    console.log(e);
    response.json({status: "KO", error: e});
  }
});

/**
 * Create challenges
 */
export const createChallenges = v2.https.onRequest(async (request, response ) => {
  try {
    for (const challenge of request.body) {
      const dto = CreateChallengeDto.fromJson(challenge);
      await ChallengeService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create companies
 */
export const createCompanies = v2.https.onRequest(async (request, response ) => {
  try {
    for (const company of request.body) {
      const dto = CreateCompanyDto.fromJson(company);
      await CompanyService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Create offers
 */
export const createOffers = v2.https.onRequest(async (request, response ) => {
  try {
    for (const offer of request.body) {
      const dto = CreateOfferDto.fromJson(offer);
      await OfferService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create levels
 */
export const createLevels = v2.https.onRequest(async (request, response ) => {
  try {
    for (const level of request.body) {
      const dto = CreateLevelDto.fromJson(level);
      await LevelService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Create organizations
 */
export const createOrganizations = v2.https.onRequest(async (request, response ) => {
  try {
    for (const organization of request.body) {
      const dto = CreateOrganizationDto.fromJson(organization);
      await OrganizationService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create projects
 */
export const createProjects = v2.https.onRequest(async (request, response ) => {
  try {
    for (const project of request.body) {
      const dto = CreateProjectDto.fromJson(project);
      await ProjectService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    console.log(e);
    response.json({status: "KO", error: e});
  }
});


/**
 * Create unlocked challenges
 */
export const createUnlockedChallenges = v2.https.onRequest(async (request, response ) => {
  try {
    for (const challenge of request.body) {
      const dto = CreateUnlockedChallengeDto.fromJson(challenge);
      await ChallengeService.createUnlocked( dto.userId, dto.challengeId);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Claim unlocked challenges
 */
export const claimUnlockedChallenge = v2.https.onRequest(async (request, response ) => {
  try {
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = ClaimUnlockedChallengeDto.fromJson(request.body);
    await ChallengeService.claimUnlocked(userId, dto.unlockedChallengeId);

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});
