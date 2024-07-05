import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/city_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Region {
  final String id;
  final String name;
  final List<City> cities;
  final GeoPoint coordinates;

  /// Initialized when all regions are fetched.
  /// Used by spots, to retrieve area names.
  /// Avoid duplication in database.
  static List<Region> allRegions = [];

  Region({required this.id, required this.name, required this.cities, required this.coordinates});

  factory Region.fromSnapshot(QueryDocumentSnapshot doc) {
    return Region(
      id: doc.id,
      name: doc['name'],
      cities: City.fromJsons(doc['cities']),
      coordinates: doc['coordinates'],
    );
  }

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json["id"],
      name: json['name'],
      cities: City.fromJsons(json['cities']),
      coordinates: json['coordinates'],
    );
  }

  static List<Region> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Region> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Region.fromSnapshot(doc));
    }
    return list;
  }

  static String getRegionNameFromId(String id) {
    for (Region region in Region.allRegions) {
      if (region.id == id) {
        return region.name;
      }
    }
    throw Exception("city not found");
  }

  static String getCityNameFromId(String regionId, String cityId) {
    for (Region region in Region.allRegions) {
      if (region.id == regionId) {
        for (City city in region.cities) {
          if (city.id == cityId) {
            return city.name;
          }
        }
      }
    }

    throw Exception("city not found");
  }

  double getLatitude() {
    return coordinates.latitude;
  }

  double getLongitude() {
    return coordinates.longitude;
  }

  Position getPosition() {
    return Position(coordinates.longitude, coordinates.latitude);
  }

  LatLng getLatLng() {
    return LatLng(coordinates.latitude, coordinates.longitude);
  }
}
