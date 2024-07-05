import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

class City {
  final String id;
  final String name;
  final int spotQuantity;
  final GeoPoint coordinates;

  City({required this.id, required this.name, required this.coordinates, required this.spotQuantity});

  factory City.fromSnapshot(QueryDocumentSnapshot doc) {
    return City(
      id: doc.id,
      name: doc['name'],
      spotQuantity: doc['spotQuantity'],
      coordinates: doc['coordinates'],
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"],
      name: json['name'],
      spotQuantity: json['spotQuantity'],
      coordinates: json['coordinates'],
    );
  }

  static List<City> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<City> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(City.fromSnapshot(doc));
    }
    return list;
  }

  static List<City> fromJsons(List<dynamic> jsons) {
    final List<City> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(City.fromJson(json));
    }
    return list;
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
