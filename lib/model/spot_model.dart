import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/common/extension/hour_extension.dart';
import 'package:hoora/model/exceptional_open_hours_model.dart';
import 'package:hoora/model/hours_model.dart';
import 'package:hoora/model/open_hours_model.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/last_crowd_report_model.dart';
import 'package:hoora/model/premium_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/super_type_model.dart';
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
  final List<LastCrowdReport> allCrowdReports;
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
    required this.allCrowdReports,
    required this.regionName,
    required this.playlistIds,
    required this.trafficPoints,
    required this.openHours,
    required this.exceptionalOpenHours,
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
      regionName: Region.getRegionNameFromId(doc['name'],doc["regionId"]),
      playlistIds: List<String>.from(doc['playlistIds']),
      density: List<int>.from(doc['density']),
      allCrowdReports: doc.data().toString().contains('allCrowdReports') ? List<LastCrowdReport>.from(doc["allCrowdReports"].map((j) {
        LastCrowdReport to = LastCrowdReport.fromJson(j);
        return to;
      })) : [],
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
      rating: doc["rating"] is int ? (doc["rating"] as int).toDouble() : doc["rating"],
      circleRadius: doc["circleRadius"] is int ? (doc["circleRadius"] as int).toDouble() : doc["circleRadius"],
      balancePremium: doc["balancePremium"] == null ? null : BalancePremium.fromJson(doc["balancePremium"]),
      pulsePremium: doc["pulsePremium"] == null ? null : PulsePremium.fromJson(doc["pulsePremium"]),
    );
  }

  static List<Spot> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Spot> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      try{
        list.add(Spot.fromSnapshot(doc));
      }catch(e,stack){
        debugPrint("Error fetching spots: ${e.toString()}" + doc['name']);
      }
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
    try{

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
    }catch(e){
    }
    return true;
  }

  String awaitingTimeAverage(DateTime date){
    if(date.day == DateTime.now().day){
      int firstSum = 0;
      int firstNum = 0;
      int secondSum = 0;
      int secondNum = 0;
      for(LastCrowdReport c in allCrowdReports){
        int hour = int.parse(c.duration.split(":")[0]);
        int minute = int.parse(c.duration.split(":")[1]);
        if(c.createdAt.day==date.day && !(hour==0 && minute==0)){
          DateTime from = c.createdAt;
          from = from.copyWith(second:0);
          DateTime currPulse30 = date.copyWith(hour: date.hour,minute: 30,second: 0);
          DateTime currMinus30 = date.copyWith(hour: date.hour-1,minute: 30,second: 0);
          DateTime currPulse1Hour = date.copyWith(hour: date.hour+1,minute: 0,second: 0);
          DateTime currMinus1Hour = date.copyWith(hour: date.hour-1,minute: 0,second: 0);

          // list of reports between [date.hour-30min,date.hour+30min]
          if ((from.isAfter(currMinus30) || from.isAtSameMomentAs(currMinus30)) && (from.isBefore(currPulse30) || from.isAtSameMomentAs(currPulse30))) {
            firstSum+=hour*60+minute;
            firstNum++;
          }
          // list of reports between [date.hour-1,date.hour-30min)
          // list of reports between (date.hour+30min,date.hour+1]
          else if (((from.isAfter(currMinus1Hour) || from.isAtSameMomentAs(currMinus1Hour)) && from.isBefore(currMinus30))
              || (from.isAfter(currPulse30) && (from.isBefore(currPulse1Hour) || from.isAtSameMomentAs(currPulse1Hour)))) {
            secondSum+=hour*60+minute;
            secondNum++;
          }
        }
      }
      if(firstNum+secondNum>0){
        int minuts =  ((secondSum*.5 +firstSum)/(firstNum+secondNum*.5)).round();
        int hour = minuts~/60;
        int minute = minuts%60;
        if (hour < 1) {
          return '$minute\'';
        }

        if (minute < 15) {
          return '${hour}h';
        }

        return '${hour}h$minute';
      }
    }
    return  '0\'';
  }

  // bool hasCrowdReportNow() {
  //   DateTime actualDay = DateTime.now();
  //   return hasCrowdReportAt(actualDay);
  // }


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

  int levelToTraffic(int level){
    var arr = [30,25,20,15,10,-10,-15,-20,-25,-30];
    return arr[level-1];
  }

  int trafficToLevel(int level){
    if(level>=0 && level<10){
      level = 10;
    }
    if(level>-10 && level<0){
      level = -10;
    }
    Map<int, int> myMap = {
      30:1,
      25:2,
      20:3,
      15:4,
      10:5,
      -10:6,
      -15:7,
      -20:8,
      -25:9,
      -30:10
    };
    try{
      return myMap[level]!;
    }catch(e){
      return -1;
    }
  }

  int calcTrafficPointUsingCrowdReport(DateTime date){
    if(date.hour>21 || date.hour<7){
      return -1;
    }
    int trafficPoint = trafficPoints[date.weekday - 1][date.hour.toString()]!;
    if(date.day==DateTime.now().day){
      int firstSum = 0;
      int firstNum = 0;
      int secondSum = 0;
      int secondNum = 0;
      for(LastCrowdReport c in allCrowdReports){
        if(date.day==c.createdAt.day){
          DateTime from = c.createdAt;
          from = from.copyWith(second:0);
          //debugPrint("hay$from");
          DateTime currPulse30 = date.copyWith(hour: date.hour,minute: 30,second: 0);
          DateTime currMinus30 = date.copyWith(hour: date.hour-1,minute: 30,second: 0);
          DateTime currPulse1Hour = date.copyWith(hour: date.hour+1,minute: 0,second: 0);
          DateTime currMinus1Hour = date.copyWith(hour: date.hour-1,minute: 0,second: 0);
          // debugPrint("hay"+currPulse30.toString());
          // debugPrint("hay"+currMinus30.toString());
          // debugPrint("hay"+currPulse1Hour.toString());
          // debugPrint("hay"+currMinus1Hour.toString());

          // list of reports between [date.hour-30min,date.hour+30min]
          if ((from.isAfter(currMinus30) || from.isAtSameMomentAs(currMinus30)) && (from.isBefore(currPulse30) || from.isAtSameMomentAs(currPulse30))) {
            firstSum+=levelToTraffic(c.intensity);
            firstNum++;
            debugPrint("hay1");
          }
          // list of reports between [date.hour-1,date.hour-30min)
          // list of reports between (date.hour+30min,date.hour+1]
          else if (((from.isAfter(currMinus1Hour) || from.isAtSameMomentAs(currMinus1Hour)) && from.isBefore(currMinus30))
              || (from.isAfter(currPulse30) && (from.isBefore(currPulse1Hour) || from.isAtSameMomentAs(currPulse1Hour)))) {
            secondSum+=levelToTraffic(c.intensity);
            secondNum++;
            //debugPrint("hay2");
          }
        }
      }
      if(firstNum+secondNum>0){
        double temp = ((trafficPoint + secondSum*.5 +firstSum)/( 1 + firstNum + secondNum*.5 ));
       //debugPrint("salma"+name+" finalTraffic before "+temp.toString());
       //debugPrint("salma"+name+" firstNum*.5 +firstNum ="+(firstNum*.5 +firstNum).toInt().toString());
        var finalTraffic = ((temp / 5).round() * 5);
       //debugPrint("salma"+name+" finalTraffic after "+finalTraffic.toString());
       //debugPrint("salma"+name+"trafficToLevel(finalTraffic)"+trafficToLevel(finalTraffic).toString());
        return finalTraffic;
      }
    }
    return -1;
  }

  int crowdReportAverageAt(DateTime date){
    try{
      var a = calcTrafficPointUsingCrowdReport(date);
      if(a == -1){
        return -1;
      }
      return trafficToLevel(calcTrafficPointUsingCrowdReport(date));
    }catch(e){
      rethrow;
    }
  }

  int getGemsAt(DateTime date) {
    if(date.hour>21 || date.hour<7){
      return 0;
    }
    int trafficPoint = trafficPoints[date.weekday - 1][date.hour.toString()]!;
    //debugPrint("salma"+name+"Traffic current "+trafficPoint.toString());
    int trafficPlusAverage = calcTrafficPointUsingCrowdReport(date);

    int gems = trafficPoint;
    ///there is a report
    if(trafficPlusAverage!=-1){
      if(trafficPlusAverage>=0 && trafficPlusAverage<10){
        trafficPlusAverage = 10;
      }
      if(trafficPlusAverage>-10 && trafficPlusAverage<0){
        trafficPlusAverage = -10;
      }
      gems = trafficPlusAverage;
    }

    if(gems<0){
      gems=0;
    }
    if(gems > 0 && isBalanceSponsoredAt(date)){
      gems += balancePremium!.gem;
    }
    if(isPulseSponsoredAt(date)){
      gems += pulsePremium!.gem;
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

  String getDistance(LatLng position) {
    double startLatitude = coordinates.latitude;
    double startLongitude = coordinates.longitude;
    double endLatitude = position.latitude;
    double endLongitude = position.longitude;

    /// In meters
    double distance = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    String out = "";
    if(distance>1000){
      out  = "${(distance/1000).toStringAsFixed(2)} Km";
    }else{
      out  = "${(distance).toStringAsFixed(0)} m";
    }
    return out;
  }

  int getPopularTimeNow() {
    DateTime date = DateTime.now().copyWith(hour: DateTime.now().getFormattedHour(), minute: 00);
    return getPopularTimeAt(date);
  }

  int getPopularTimeAt(DateTime date) {
    return popularTimes[date.weekday - 1][date.hour.toString()]!;
  }

  int getTrafficPointAt(DateTime date) {
    try{
      return trafficPoints[date.weekday - 1][date.hour.toString()]!;
    }catch(e){
      return -1;
    }
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

  String superTypeImagePath(List<SuperType> supers){
    String s2="" ;
    for(SuperType s in supers){
      if(s.name=="Lieux dʼintéret"){
        s2= s.image;
      }
      for(String t in s.types){
        if(t.toLowerCase()==type.toLowerCase()){
         // debugPrint("superTypeImagePath:"+s.name);
          return s.image;
        }
      }
    }
    if(s2.isEmpty){
      return '<svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path fill-rule="evenodd" clip-rule="evenodd" d="M4.71798 22.0403V11.8139C2.0279 11.2366 0 8.82436 0 5.97912C0 2.6803 2.69008 0 6.00094 0C9.31181 0 12.0019 2.6803 12.0019 5.97912C12.0019 8.82436 9.97398 11.2366 7.2839 11.8139V22.0403C7.2839 22.7413 6.7045 23.3186 6.00094 23.3186C5.29738 23.3186 4.71798 22.7413 4.71798 22.0403ZM10.4706 5.97912C10.4706 3.52562 8.4634 1.52571 6.00094 1.52571C4.39168 1.52571 2.97685 2.37984 2.18962 3.65652C2.95184 2.8812 4.01268 2.40039 5.18582 2.40039C7.50622 2.40039 9.38727 4.28144 9.38727 6.60184C9.38727 8.16173 8.53719 9.52307 7.27501 10.2479C9.11981 9.69932 10.4706 7.99185 10.4706 5.97912Z" fill="#153330"/> </svg>';
    }
    return s2;
  }
}
