import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'model/city_model.dart';
import 'model/offer_model.dart';
import 'model/region_model.dart';
import 'model/spot_model.dart';

class Tools {

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double calculateDistance2(LatLng first,LatLng sec) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degToRad(sec.latitude - first.latitude);
    double dLon = _degToRad(sec.longitude - first.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(first.latitude)) * cos(_degToRad(sec.latitude)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degToRad(double deg) {
    return deg * (pi / 180);
  }
  static Region findClosestRegion(regions,LatLng userPosition){
    var closestRegion = regions[0];
    var x = double.infinity;
    for(Region reg in regions){
      var b = calculateDistance(reg.coordinates.latitude,reg.coordinates.longitude,userPosition.latitude,userPosition.longitude);
      if(b<x){
        x = b;
        closestRegion = reg;
      }
    }
    return closestRegion;
  }

  static City findClosestCity(cities,LatLng userPosition){
    var closetCity = cities[0];
    var x = double.infinity;
    for(City city in cities){
      var b = calculateDistance(city.coordinates.latitude,city.coordinates.longitude,userPosition.latitude,userPosition.longitude);
      if(b<x){
        x = b;
        closetCity = city;
      }
    }
    return closetCity;
  }

  static List<Spot> findClosestSpots(List<Spot> spots,LatLng userPosition){
    var n = spots.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        var disA = Tools.calculateDistance(spots[j].coordinates.latitude, spots[j].coordinates.longitude, userPosition.latitude, userPosition.longitude);
        var disB = Tools.calculateDistance(spots[j+1].coordinates.latitude, spots[j+1].coordinates.longitude, userPosition.latitude, userPosition.longitude);
        if (disA > disB) {
          var temp = spots[j];
          spots[j] = spots[j + 1];
          spots[j + 1] = temp;
        }
      }
    }
    if(spots.length<=5){
      return spots;
    }else{
      return spots.getRange(0, 5).toList();
    }
  }

  static List<Spot> findClosestSpotsByThreshold (List<Spot> spots,LatLng userPosition,double threshold ){
    List<Spot> filterSpot = [];
    for (int j = 0; j < spots.length; j++) {
      var disA = Tools.calculateDistance(spots[j].coordinates.latitude, spots[j].coordinates.longitude, userPosition.latitude, userPosition.longitude);
      if(disA<=threshold && !spots[j].isClosedAt(DateTime.now(),onlyHour: false)){
        filterSpot.add(spots[j]);
      }
    }
    for (int i = 0; i < filterSpot.length - 1; i++) {
      for (int j = 0; j < filterSpot.length - i - 1; j++) {
        var disA = Tools.calculateDistance(filterSpot[j].coordinates.latitude, filterSpot[j].coordinates.longitude, userPosition.latitude, userPosition.longitude);
        var disB = Tools.calculateDistance(filterSpot[j+1].coordinates.latitude, filterSpot[j+1].coordinates.longitude, userPosition.latitude, userPosition.longitude);
        if (disA > disB) {
          var temp = filterSpot[j];
          filterSpot[j] = filterSpot[j + 1];
          filterSpot[j + 1] = temp;
        }
      }
    }
    if(filterSpot.length<=10){
      return filterSpot;
    }else{
      return filterSpot.getRange(0, 10).toList();
    }
  }

  static List<Offer> findClosestOffersByThreshold (List<Offer> offers,LatLng userPosition,double threshold,String cityId){
    List<Offer> finalOffers  = [];
    for (int j = 0; j < offers.length; j++) {
      var locationsTemp = offers[j].locations.where((location) {
        var disA = Tools.calculateDistance(location.point.latitude, location.point.longitude, userPosition.latitude, userPosition.longitude);
        return location.cityId == cityId && disA <threshold;
      }).toList();


      if(locationsTemp.isNotEmpty){
        locationsTemp.sort((a, b) {
          var disA = Tools.calculateDistance(
            a.point.latitude,
            a.point.longitude,
            userPosition.latitude,
            userPosition.longitude,
          );
          var disB = Tools.calculateDistance(
            b.point.latitude,
            b.point.longitude,
            userPosition.latitude,
            userPosition.longitude,
          );
          return disA.compareTo(disB);
        },);
        var off = offers[j];
        off.locations.clear();
        off.locations.add(locationsTemp.first);
        finalOffers.add(off);
      }
    }
    finalOffers.sort((a, b) {
      var disA = Tools.calculateDistance(
        a.locations[0].point.latitude,
        a.locations[0].point.longitude,
        userPosition.latitude,
        userPosition.longitude,
      );

      var disB = Tools.calculateDistance(
        b.locations[0].point.latitude,
        b.locations[0].point.longitude,
        userPosition.latitude,
        userPosition.longitude,
      );

      return disA.compareTo(disB);
    });
    return finalOffers;
  }


  static Future<Position> enableLocation() async {
    await requestLocationPermission();
    return await checkLocationService();
  }

   static Future<void> requestLocationPermission() async {
     LocationPermission permission = await Geolocator.checkPermission();

     if (permission == LocationPermission.denied) {
       // Permission denied, ask the user to grant it
       await Geolocator.requestPermission();
     } else if (permission == LocationPermission.deniedForever) {
       // Permission is permanently denied, direct user to settings
     }
   }

  static Future<Position> checkLocationService() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

}