import * as gcloud from "@google-cloud/firestore";
import {ExceptionalOpenHoursEntity} from "./exceptional_open_hours.entity";
import {OpenHoursEntity} from "./open_hours.entity";
import {LastCrowdReportEntity} from "./last_crowd_report.entity";
import {BalancePremiumEntity} from "./balance_premium.entity";
import {PulsePremiumEntity} from "./pulse_premium.entity";
import {DocumentData} from "firebase-admin/firestore";
import {TarificationEntity} from "./tarification.entity";

export class SpotEntity {
  id: string;
  fullPrice: TarificationEntity | null;
  reducedPrice: TarificationEntity | null;
  freePrice: TarificationEntity | null;
  name: string;
  score: number;
  imageCardPath: string;
  imageIsoPath: string;
  imageGalleryPaths: string;
  visitDuration: string;
  type: string;
  website: string;
  description: string;
  tips: string[];
  highlights: string[];
  coordinates: gcloud.GeoPoint;
  cityId: string;
  circleRadius: number;
  regionId: string;
  playlistIds: string[];
  density: number[];
  exceptionalOpenHours: ExceptionalOpenHoursEntity[];
  openHours: OpenHoursEntity[];
  trafficPoints: Map<string, number>[];
  popularTimes: Map<string, number>[];
  lastCrowdReport: LastCrowdReportEntity | null;
  balancePremium: BalancePremiumEntity | null;
  pulsePremium: PulsePremiumEntity | null;
  rating: number;


  constructor({
    id,
    score,
    fullPrice,
    reducedPrice,
    freePrice,
    name,
    imageGalleryPaths,
    visitDuration,
    type,
    website,
    description,
    tips,
    highlights,
    imageCardPath,
    imageIsoPath,
    coordinates,
    cityId,
    density,
    circleRadius,
    regionId,
    popularTimes,
    playlistIds,
    exceptionalOpenHours,
    openHours,
    trafficPoints,
    lastCrowdReport,
    balancePremium,
    pulsePremium,
    rating,
  } : {
        id: string,

        fullPrice: TarificationEntity | null;
        reducedPrice: TarificationEntity | null;
        freePrice: TarificationEntity | null;
        score: number,
        name: string,
        imageGalleryPaths: string;
        visitDuration: string;
        type: string;
        website: string;
        description: string;
        tips: string[];
        highlights: string[];
        imageCardPath: string,
        imageIsoPath: string,
        coordinates: gcloud.GeoPoint,
        cityId: string,
        regionId: string,
        playlistIds: string[],
        density: number[],
        exceptionalOpenHours: ExceptionalOpenHoursEntity[],
        openHours: OpenHoursEntity[],
        trafficPoints: Map<string, number>[],
        popularTimes: Map<string, number>[],
        lastCrowdReport: LastCrowdReportEntity | null,
        balancePremium: BalancePremiumEntity | null,
        pulsePremium: PulsePremiumEntity | null,
        rating: number,
        circleRadius: number,
       }) {
    this.id = id;

    this.fullPrice = fullPrice;
    this.reducedPrice = reducedPrice;
    this.score = score;
    this.freePrice = freePrice;

    this.imageGalleryPaths = imageGalleryPaths;
    this.visitDuration = visitDuration;
    this.type = type;
    this.website = website;
    this.description = description;
    this.tips = tips;
    this.highlights = highlights;
    this.name = name;
    this.imageCardPath = imageCardPath;
    this.imageIsoPath = imageIsoPath;
    this.coordinates = coordinates;
    this.cityId = cityId;
    this.regionId = regionId;
    this.popularTimes = popularTimes;
    this.circleRadius = circleRadius;
    this.playlistIds = playlistIds;
    this.density = density;
    this.exceptionalOpenHours = exceptionalOpenHours;
    this.openHours = openHours;
    this.trafficPoints = trafficPoints;
    this.lastCrowdReport = lastCrowdReport;
    this.balancePremium = balancePremium;
    this.pulsePremium = pulsePremium;
    this.rating = rating;
  }

  static fromSnapshot(snapshot: DocumentData): SpotEntity {
    const json = snapshot.data();
    const entity = new SpotEntity({
      id: snapshot.id,
      name: json.name,
      score: json.score,
      fullPrice: TarificationEntity.fromJson(json.fullPrice),
      reducedPrice: TarificationEntity.fromJson(json.reducedPrice),
      freePrice: TarificationEntity.fromJson(json.freePrice),

      imageCardPath: json.imageCardPath,
      imageGalleryPaths: json.imageGalleryPaths,
      website: json.website,
      type: json.type,
      tips: json.tips,
      highlights: json.highlights,
      visitDuration: json.visitDuration,
      description: json.description,
      imageIsoPath: json.imageIsoPath,
      coordinates: json.coordinates,
      cityId: json.cityId,
      regionId: json.regionId,
      playlistIds: json.playlistIds,
      exceptionalOpenHours: ExceptionalOpenHoursEntity.fromJsons(
        json.exceptionalOpenHours),
      openHours: OpenHoursEntity.fromJsons(json.openHours),
      trafficPoints: json.trafficPoints.map((entries: any) => {
        const map = new Map(Object.entries(entries));
        return map;
      }),
      lastCrowdReport: LastCrowdReportEntity.fromJson(json.lastCrowdReport),
      balancePremium: BalancePremiumEntity.fromJson(json.balancePremium),
      pulsePremium: PulsePremiumEntity.fromJson(json.pulsePremium),
      rating: json.rating,
      popularTimes: json.trafficPoints.map((entries: any) => {
        const map = new Map(Object.entries(entries));
        return map;
      }),
      circleRadius: json.circleRadius,
      density: json.density,
    });
    return entity;
  }


  getGemsNow() : number {
    const date: Date = new Date(Date.now());
    // UTC to french
    date.setHours(date.getHours() + 2);

    const hour = date.getHours();
    if (hour < 7 || hour > 21) {
      date.setHours(10);
    }

    return this.getGemsAt(date);
  }


  isPulseSponsoredAt(date: Date) : boolean {
    if (this.pulsePremium === null) {
      return false;
    }

    if (date > this.pulsePremium!.from && date < this.pulsePremium!.to) {
      return true;
    }

    return false;
  }

  isBalanceSponsoredAt(date : Date) {
    if (this.balancePremium == null) {
      return false;
    }

    if (date > this.balancePremium!.from && date < this.balancePremium!.to) {
      const gems : number = this.trafficPoints[this.getWeekDay(date) - 1].get(date.getHours().toString())!;
      if (gems <= 0) {
        return false;
      }

      return true;
    }
    return false;
  }

  hasDiscoveryPoints(date : Date) : boolean {
    const density = this.getDensityAt(date);
    return density < 3 && this.rating >= 4.5;
  }

  getDensityNow() : number {
    const date = new Date();
    // UTC to french
    date.setHours(date.getHours() + 2);
    return this.getDensityAt(date);
  }

  getDensityAt(date: Date) : number {
    const month = date.getMonth();
    return this.density[month];
  }

  getGemsAt( date: Date) : number {
    let gems: number = this.trafficPoints[this.getWeekDay(date) - 1].get(date.getHours().toString())!;

    if (gems > 0 && this.isBalanceSponsoredAt(date)) {
      gems += this.balancePremium!.gem;
    }

    if (this.isPulseSponsoredAt(date)) {
      gems += this.pulsePremium!.gem;
    }

    if (this.hasDiscoveryPoints(date)) {
      gems += 5;
    }
    return gems;
  }

  getWeekDay(date : Date) {
    const weekDays = [7, 1, 2, 3, 4, 5, 6];
    return weekDays[date.getDay()];
  }
}


