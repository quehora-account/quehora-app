import * as gcloud from "@google-cloud/firestore";
import {OpenHoursDto} from "./open_hours.dto";
import {ExceptionalOpenHoursDto} from "./exceptional_open_hours.dto";
import {LastCrowdReportDto} from "./last_crowd_report.dto";
import {BalancePremiumDto} from "./balance_premium.dto";
import {PulsePremiumDto} from "./pulse_premium.dto";
import {TarificationDto} from "./tarification.dto";

export class CreateSpotDto {
  name: string;
  fullPrice: TarificationDto | null;
  reducedPrice: TarificationDto | null;
  freePrice: TarificationDto | null;
  imageCardPath: string;
  imageIsoPath: string;
  imageGalleryPaths: string;
  visitDuration: string;
  score: number;
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
  exceptionalOpenHours: ExceptionalOpenHoursDto[];
  openHours: OpenHoursDto[];
  popularTimes: Map<string, number>[];
  lastCrowdReport: LastCrowdReportDto | null;
  balancePremium: BalancePremiumDto | null;
  pulsePremium: PulsePremiumDto | null;
  rating: number;


  constructor({
    name,
    fullPrice,
    reducedPrice,
    freePrice,
    imageGalleryPaths,
    visitDuration,
    type,
    website,
    description,
    tips,
    score,
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
    lastCrowdReport,
    balancePremium,
    pulsePremium,
    rating,
  } : {
        name: string,
        fullPrice: TarificationDto | null;
        reducedPrice: TarificationDto | null;
        freePrice: TarificationDto | null;
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
        score: number,
        playlistIds: string[],
        density: number[],
        exceptionalOpenHours: ExceptionalOpenHoursDto[],
        openHours: OpenHoursDto[],
        popularTimes: Map<string, number>[],
        lastCrowdReport: LastCrowdReportDto | null,
        balancePremium: BalancePremiumDto | null,
        pulsePremium: PulsePremiumDto | null,
        rating: number,
        circleRadius: number,
       }) {
    this.name = name;
    this.fullPrice = fullPrice;
    this.reducedPrice = reducedPrice;
    this.freePrice = freePrice;
    this.imageGalleryPaths = imageGalleryPaths;
    this.visitDuration = visitDuration;
    this.type = type;
    this.website = website;
    this.description = description;
    this.tips = tips;
    this.highlights = highlights;
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
    this.lastCrowdReport = lastCrowdReport;
    this.balancePremium = balancePremium;
    this.pulsePremium = pulsePremium;
    this.rating = rating;
    this.score = score;
  }

  static fromJson(json: any): CreateSpotDto {
    const dto = new CreateSpotDto({
      name: json.name,
      fullPrice: TarificationDto.fromJson(json.fullPrice),
      reducedPrice: TarificationDto.fromJson(json.reducedPrice),
      freePrice: TarificationDto.fromJson(json.freePrice),
      imageGalleryPaths: json.imageGalleryPaths,
      type: json.type,
      score: json.score,
      tips: json.tips,
      description: json.description,
      highlights: json.highlights,
      website: json.website,
      visitDuration: json.visitDuration,
      imageCardPath: json.imageCardPath,
      imageIsoPath: json.imageIsoPath,
      coordinates: new gcloud.GeoPoint(json.coordinates[0],
        json.coordinates[1]),
      cityId: json.cityId,
      regionId: json.regionId,
      playlistIds: json.playlistIds,
      exceptionalOpenHours: ExceptionalOpenHoursDto.fromJsons(
        json.exceptionalOpenHours),
      openHours: OpenHoursDto.fromJsons(json.openHours),
      lastCrowdReport: LastCrowdReportDto.fromJson(json.lastCrowdReport),
      balancePremium: BalancePremiumDto.fromJson(json.balancePremium),
      pulsePremium: PulsePremiumDto.fromJson(json.pulsePremium),
      rating: json.rating,
      popularTimes: json.popularTimes,
      circleRadius: json.circleRadius,
      density: json.density,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): CreateSpotDto[] {
    const list: CreateSpotDto[] = [];
    for (const json of jsons) {
      const elem = CreateSpotDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : any {
    return {
      "name": this.name,
      "imageGalleryPaths": this.imageGalleryPaths,
      "tips": this.tips,
      "description": this.description,
      "highlights": this.highlights,
      "visitDuration": this.visitDuration,
      "score": this.score,
      "website": this.website,
      "type": this.type,
      "imageCardPath": this.imageCardPath,
      "imageIsoPath": this.imageIsoPath,
      "coordinates": this.coordinates,
      "cityId": this.cityId,
      "regionId": this.regionId,
      "playlistIds": this.playlistIds,
      "exceptionalOpenHours": ExceptionalOpenHoursDto.toJsons(
        this.exceptionalOpenHours),
      "openHours": OpenHoursDto.toJsons(this.openHours),
      "popularTimes": this.popularTimes,
      "lastCrowdReport": this.lastCrowdReport?.toJson() ?? null,
      "balancePremium": this.balancePremium?.toJson() ?? null,
      "pulsePremium": this.pulsePremium?.toJson() ?? null,
      "rating": this.rating,
      "circleRadius": this.circleRadius,
      "density": this.density,
      "fullPrice": this.fullPrice?.toJson() ?? null,
      "reducedPrice": this.reducedPrice?.toJson() ?? null,
      "freePrice": this.freePrice?.toJson() ?? null,
    };
  }

  static toJsons(dtos : CreateSpotDto[]) : object[] {
    const list: object[] = [];
    for (const dto of dtos) {
      const elem = dto.toJson();
      list.push(elem);
    }
    return list;
  }
}
