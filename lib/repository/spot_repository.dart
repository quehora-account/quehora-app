import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:http/http.dart' as http;

class SpotRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  List<Spot> suggestionList = [];

  Future<List<Spot>> getSpotsByCity2(City city) async {
    QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
        .collection("spot")
        .where("cityId",isEqualTo: city.id)
        .get();

    return Spot.fromSnapshots(spotSnapshot.docs);
  }
  Stream<CityAndSpots> getSpotsBySearchStream(String search, String zone, List<Region> regions,selectedRegion) {
    if (search.isNotEmpty) {
      for (Region region in regions) {
        for (City city in region.cities) {
          if (city.name.replaceAll("é", "e").replaceAll("è", "e").replaceAll("â", "a").toLowerCase().contains(search.toLowerCase())) {
            Stream<QuerySnapshot> spotStream;
            if (zone == "region") {
              spotStream = FirebaseFirestore.instance
                  .collection("spot")
                  .where("regionId", isEqualTo: region.id)
                  .snapshots();
              debugPrint("Dick regionId ${region.id}");
            } else {
              spotStream = FirebaseFirestore.instance
                  .collection("spot")
                  .where("cityId", isEqualTo: city.id)
                  .snapshots();
              debugPrint("Dick cityId ${city.id}");

            }

            return spotStream.map((snapshot) {
              List<Spot> spots = Spot.fromSnapshots(snapshot.docs);
              debugPrint("Dick ${spots.length}");
              return CityAndSpots(city: city, spots: spots, region: region);
            });
          }
        }
      }
      return Stream.value(CityAndSpots(city: null, spots: [], region: null));
    } else {

      return FirebaseFirestore.instance.collection("spot")
          .where("regionId", isEqualTo: selectedRegion.id)
          .snapshots().map((snapshot) {
        List<Spot> allSpots = Spot.fromSnapshots(snapshot.docs);
        //debugPrint("SALAM"+allSpots.length.toString());
        return CityAndSpots(city: null, spots: allSpots, region: null);
      });
    }
  }

  Future<CityAndSpots> getSpotsBySearch2(String search,String zone,regions) async{
    List<Spot> allSpots = [];
    Region? selectedRegion;
    City?  searchedCity ;
    if(search.isNotEmpty){


      for(Region region in regions){
        for(City city in region.cities){
          if(city.name.replaceAll("é", "e").replaceAll("è", "e").replaceAll("â", "a").toLowerCase().contains(search.toLowerCase())){
            debugPrint("found city name :${city.name}");
            QuerySnapshot spotSnapshot;

            if(zone=="region"){
              //find a city name by search and give the all spots that are in region of that city
              spotSnapshot = await FirebaseFirestore.instance.collection("spot").where("regionId", isEqualTo: region.id).get();
            }else{
              //find a city name by search and give the all spots that are in that city
              spotSnapshot = await FirebaseFirestore.instance.collection("spot").where("cityId", isEqualTo: city.id).get();
            }
            List<Spot> spots = Spot.fromSnapshots(spotSnapshot.docs);
            allSpots.addAll(spots);
            searchedCity= city;
            selectedRegion= region;
            break;
          }
        }
      }
    }else{
      QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
          .collection("spot")
          .get();

      allSpots = Spot.fromSnapshots(spotSnapshot.docs);
    }
    debugPrint("allSpots${allSpots.length}");

    return CityAndSpots(city: searchedCity, spots: allSpots, region: selectedRegion);
  }

  Future<List<Spot>> get5SpotSuggestion(String search) async {
    try {
      if (suggestionList.isEmpty) {
        QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
            .collection("spot")
            .get();

        suggestionList = Spot.fromSnapshots(spotSnapshot.docs);
      }
      debugPrint("omad shod2 " + suggestionList.length.toString());

      List<Spot> spots = [];
      for (Spot s in suggestionList) {
        if (s.name
            .replaceAll("é", "e")
            .replaceAll("è", "e")
            .replaceAll("â", "a")
            .toLowerCase()
            .contains(search.toLowerCase())) {
          spots.add(s);
          if (spots.length == 6) {
            break;
          }
        }
      }
      return spots;
    } catch (e ,stackTrace) {
      debugPrint("Error fetching spots: $e");
      debugPrint("Stack Trace: $stackTrace");

      return []; // Return an empty list if an error occurs
    }
  }

  Future<bool> spotAlreadyValidated(Spot spot) async {
    QuerySnapshot snapshot = await instance
        .collection("spotValidation")
        .where("spotId", isEqualTo: spot.id)
        .where("userId", isEqualTo: authInstance.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    DateTime createdAt = (snapshot.docs[0]["createdAt"] as Timestamp).toDate();
    DateTime end = DateTime.now();

    return createdAt.day == end.day;
  }

  Future<void> validateSpot(Spot spot, List coordinates) async {
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://validatespot-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://validatespot-5lgw4vxlaa-uc.a.run.app');
    await http.post(
      url,
      body: {
        'spotId': spot.id,
        'coordinates': coordinates.toString(),
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }

  Future<List<Spot>> getSpotsBySearch(String search) async{
    List<Spot> allSpots = [];
    if(search.isNotEmpty){
      QuerySnapshot citySnapshot = await FirebaseFirestore.instance
          .collection('region')
          .get();

      List<Region> regions = Region.fromSnapshots(citySnapshot.docs);
      List<City> cities = [];
      for(Region region in regions){
        for(City c in region.cities){
          if(c.name.toLowerCase().contains(search.toLowerCase())){
            cities.add(c);
          }
        }
      }
      // Initialize a list to store the spots
      debugPrint("cities${cities.length}");
      debugPrint("search text :  $search");

      //Fetch spots for each city
      for (City city in cities) {
        debugPrint("dick${city.name}");
        QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
            .collection("spot")
            .where("cityId", isEqualTo: city.id)
            .get();

        List<Spot> spots = Spot.fromSnapshots(spotSnapshot.docs);
        allSpots.addAll(spots);
      }
      debugPrint("allSpots${allSpots.length}");
    }else{
      QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
          .collection("spot")
          .get();

      allSpots = Spot.fromSnapshots(spotSnapshot.docs);
    }

    return allSpots;
  }
}

class CityAndSpots {
  City? city;
  Region? region;
  final List<Spot> spots;

  CityAndSpots({required this.city, required this.spots, required this.region});
}
