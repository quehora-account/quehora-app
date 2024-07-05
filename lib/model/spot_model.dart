import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/common/extension/hour_extension.dart';
import 'package:hoora/model/exceptional_open_hours_model.dart';
import 'package:hoora/model/hours_model.dart';
import 'package:hoora/model/open_hours_model.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/last_crowd_report_model.dart';
import 'package:hoora/model/premium_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/tarification_model.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

var fallback = [
      {
        "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      },
      {
          "7": 0,
        "8": 0,
        "9": 0,
        "10": 0,
        "11": 0,
        "12": 0,
        "13": 0,
        "14": 0,
        "15": 0,
        "16": 0,
        "17": 0,
        "18": 0,
        "19": 0,
        "20": 0,
        "21": 0
      }
    ];

class Spot {
  final String id;
  final String name;
  final int score;
  final String imageCardPath;
  final String imageIsoPath;
  final TarificationModel? fullPrice;
  final TarificationModel? reducedPrice;
  final TarificationModel? freePrice;
  final List<String> imageGalleryPaths;
  final List<String> tips;
  final List<String> highlights;
  final String description;
  final String visitDuration;
  final String website;
  final String type;
  final GeoPoint coordinates;
  final String cityId;
  final String regionId;
  final String cityName;
  final String regionName;
  final List<String> playlistIds;
  final List<Map<String, int>> trafficPoints;
  final List<Map<String, int>> popularTimes;
  final List<int> density;
  final double circleRadius;
  final List<OpenHours> openHours;
  final List<ExceptionalOpenHours> exceptionalOpenHours;
  final LastCrowdReport? lastCrowdReport;
  final BalancePremium? balancePremium;
  final PulsePremium? pulsePremium;
  final double rating;

  Spot({
    required this.id,
    required this.name,
    required this.fullPrice,
    required this.reducedPrice,
    required this.score,
    required this.freePrice,
    required this.imageCardPath,
    required this.imageIsoPath,
    required this.coordinates,
    required this.imageGalleryPaths,
    required this.tips,
    required this.highlights,
    required this.description,
    required this.visitDuration,
    required this.website,
    required this.type,
    required this.cityId,
    required this.circleRadius,
    required this.density,
    required this.popularTimes,
    required this.regionId,
    required this.cityName,
    required this.regionName,
    required this.playlistIds,
    required this.trafficPoints,
    required this.openHours,
    required this.exceptionalOpenHours,
    required this.lastCrowdReport,
    required this.rating,
    this.balancePremium,
    this.pulsePremium,
  });

  factory Spot.fromSnapshot(QueryDocumentSnapshot doc) {
    return Spot(
      id: doc.id,
      fullPrice: TarificationModel.fromJson(doc["fullPrice"]),
      reducedPrice: TarificationModel.fromJson(doc["reducedPrice"]),
      freePrice: TarificationModel.fromJson(doc["freePrice"]),
      name: doc['name'],
      score: doc['score'],
      imageCardPath: doc['imageCardPath'],
      imageGalleryPaths: List<String>.from(doc['imageGalleryPaths']),
      tips: List<String>.from(doc['tips']),
      highlights: List<String>.from(doc['highlights']),
      website: doc['website'],
      description: doc['description'],
      type: doc['type'],
      visitDuration: doc['visitDuration'],
      imageIsoPath: doc['imageIsoPath'],
      coordinates: doc['coordinates'],
      cityId: doc['cityId'],
      regionId: doc['regionId'],
      cityName: Region.getCityNameFromId(doc["regionId"], doc["cityId"]),
      regionName: Region.getRegionNameFromId(doc["regionId"]),
      playlistIds: List<String>.from(doc['playlistIds']),
      density: List<int>.from(doc['density']),
      trafficPoints: doc.data().toString().contains('trafficPoints') ? List<Map<String, int>>.from(doc["trafficPoints"].map((from) {
        Map<String, int> to = Map<String, int>.from(from);
        return to;
      })) : fallback,
      popularTimes: List<Map<String, int>>.from(doc["popularTimes"].map((from) {
        Map<String, int> to = Map<String, int>.from(from);
        return to;
      })),
      openHours: OpenHours.fromJsons(doc["openHours"]),
      exceptionalOpenHours: ExceptionalOpenHours.fromJsons(doc["exceptionalOpenHours"]),
      lastCrowdReport: doc["lastCrowdReport"] == null ? null : LastCrowdReport.fromJson(doc["lastCrowdReport"]),
      rating: doc["rating"] is int ? (doc["rating"] as int).toDouble() : doc["rating"],
      circleRadius: doc["circleRadius"] is int ? (doc["circleRadius"] as int).toDouble() : doc["circleRadius"],
      balancePremium: doc["balancePremium"] == null ? null : BalancePremium.fromJson(doc["balancePremium"]),
      pulsePremium: doc["pulsePremium"] == null ? null : PulsePremium.fromJson(doc["pulsePremium"]),
    );
  }

  static List<Spot> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Spot> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Spot.fromSnapshot(doc));
    }
    return list;
  }

  List<Hours>? getExceptionalOpenHoursAt(DateTime date) {
    for (ExceptionalOpenHours exceptionalOpenHours in exceptionalOpenHours) {
      DateTime day = exceptionalOpenHours.date;

      if (date.month == day.month && date.day == day.day) {
        return exceptionalOpenHours.hours;
      }
    }
    return null;
  }

  bool isClosedAt(DateTime date, {bool onlyHour = true}) {
    DateFormat format = DateFormat("HH:mm");

    for (ExceptionalOpenHours exceptionalOpenHours in exceptionalOpenHours) {
      DateTime day = exceptionalOpenHours.date;

      if (date.month == day.month && date.day == day.day) {
        for (Hours hours in exceptionalOpenHours.hours) {
          DateTime start = format.parse(hours.start);
          DateTime end = format.parse(hours.end);

          DateTime selected = format.parse("${date.hour}:${date.minute}");
          if (onlyHour) {
            selected = format.parse("${date.hour}:00");
          }
          if ((selected.isAtSameMomentAs(start) || selected.isAfter(start)) && selected.isBefore(end)) {
            return false;
          }
        }
        return true;
      }
    }

    for (Hours hours in openHours[date.weekday - 1].hours) {
      DateTime start = format.parse(hours.start);
      DateTime end = format.parse(hours.end);
      DateTime selected = format.parse("${date.hour}:${date.minute}");
      if (onlyHour) {
        selected = format.parse("${date.hour}:00");
      }
      if ((selected.isAtSameMomentAs(start) || selected.isAfter(start)) && selected.isBefore(end)) {
        return false;
      }
    }

    return true;
  }

  bool isAwaitingTimeNow() {
    if (lastCrowdReport == null) {
      return false;
    }
    DateTime date = DateTime.now();
    return isAwaitingTimeAt(date);
  }

  bool isAwaitingTimeAt(DateTime date) {
    if (lastCrowdReport == null) {
      return false;
    }

    DateTime from = lastCrowdReport!.createdAt;
    DateTime to = from.add(const Duration(hours: 2));

    if (date.year == from.year && date.month == from.month && date.day == from.day) {
      if (date.hour >= from.hour && date.hour < to.hour) {
        int hour = int.parse(lastCrowdReport!.duration.split(":")[0]);
        int minute = int.parse(lastCrowdReport!.duration.split(":")[1]);
        if (hour == 0 && minute == 00) {
          return false;
        }

        return true;
      }
    }
    return false;
  }

  bool hasCrowdReportNow() {
    DateTime actualDay = DateTime.now();
    return hasCrowdReportAt(actualDay);
  }

  bool hasCrowdReportAt(DateTime date) {
    if (lastCrowdReport == null) {
      return false;
    }

    DateTime from = lastCrowdReport!.createdAt;
    DateTime to = from.add(const Duration(hours: 2));

    if ((date.isAtSameMomentAs(from) || date.isAfter(from)) && date.isBefore(to)) {
      return true;
    }
    return false;
  }

  bool isSponsoredNow() {
    DateTime date = DateTime.now().copyWith(hour: DateTime.now().getFormattedHour(), minute: 00);
    return isSponsoredAt(date);
  }

  bool isSponsoredAt(DateTime date) {
    if (isBalanceSponsoredAt(date) || isPulseSponsoredAt(date)) {
      return true;
    }
    return false;
  }

  bool isPulseSponsoredAt(DateTime date) {
    if (pulsePremium == null) {
      return false;
    }

    if (date.isAfter(pulsePremium!.from) && date.isBefore(pulsePremium!.to)) {
      return true;
    }
    return false;
  }

  bool isBalanceSponsoredAt(DateTime date) {
    if (balancePremium == null) {
      return false;
    }

    if (date.isAfter(balancePremium!.from) && date.isBefore(balancePremium!.to)) {
      int gems = trafficPoints[date.weekday - 1][date.hour.toString()]!;
      if (gems <= 0) {
        return false;
      }

      return true;
    }
    return false;
  }

  bool hasDiscoveryPoints(DateTime date) {
    int density = getDensityAt(date);

    return density < 3 && rating >= 4.5;
  }

  bool hasPlaylist(Playlist? playlist) {
    if (playlist == null) {
      return true;
    }

    for (String playlistId in playlistIds) {
      if (playlistId == playlist.id) {
        return true;
      }
    }
    return false;
  }

  int getGemsNow() {
    DateTime date = DateTime.now().copyWith(hour: DateTime.now().getFormattedHour(), minute: 00);
    return getGemsAt(date);
  }

  int getGemsAt(DateTime date) {
    int gems = trafficPoints[date.weekday - 1][date.hour.toString()]!;

    if (gems > 0 && isBalanceSponsoredAt(date)) {
      gems += balancePremium!.gem;
    }

    if (isPulseSponsoredAt(date)) {
      gems += pulsePremium!.gem;
    }

    if (hasDiscoveryPoints(date)) {
      gems += 5;
    }
    return gems;
  }

  LatLng getLatLng() {
    return LatLng(coordinates.latitude, coordinates.longitude);
  }

  bool isInCircleRadius(LatLng position) {
    double startLatitude = coordinates.latitude;
    double startLongitude = coordinates.longitude;
    double endLatitude = position.latitude;
    double endLongitude = position.longitude;

    /// In meters
    double distance = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);

    return distance <= circleRadius;
  }

  int getPopularTimeNow() {
    DateTime date = DateTime.now().copyWith(hour: DateTime.now().getFormattedHour(), minute: 00);
    return getPopularTimeAt(date);
  }

  int getPopularTimeAt(DateTime date) {
    return popularTimes[date.weekday - 1][date.hour.toString()]!;
  }

  int getDensityNow() {
    DateTime date = DateTime.now();
    return getDensityAt(date);
  }

  int getDensityAt(DateTime date) {
    int month = date.month;
    return density[month - 1];
  }

  bool hasOpenHoursAt(int weekday) {
    return openHours[weekday - 1].hours.isEmpty;
  }
}
