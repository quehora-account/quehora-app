import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:http/http.dart' as http;

import '../model/city_model.dart';
import '../model/region_model.dart';

class OfferRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Stream<List<Offer>> getAllOffersStream() {
    return instance.collection("offer").snapshots().map((snapshot) => Offer.fromSnapshots(snapshot.docs));
  }

  Future<List<Offer>> getAllOffers() async {
    QuerySnapshot snapshot = await instance.collection("offer").get();
    return Offer.fromSnapshots(snapshot.docs);
  }


  //must removed
  Future<List<Offer>> getOffers() async {

    await for (List<Offer> list in getAllOffersStream()) {
      List<Offer> offers = list;
      List<Offer> filteredOffers = [];
      debugPrint("SALAM getOffers");
      for (Offer offer in offers) {
        if (offer.codes.isEmpty) {
          continue;
        }
        if (offer.from.isAfter(DateTime.now())) {
          continue;
        }

        if (offer.to != null && offer.to!.isBefore(DateTime.now())) {
          continue;
        }

        filteredOffers.add(offer);
      }
      return filteredOffers;
    }

    return [];
  }

  Future<List<UnlockedOffer>> getUnlockedOffers() async {
    QuerySnapshot snapshot = await instance
        .collection("unlockedOffer")
        .where(
          "userId",
          isEqualTo: authInstance.currentUser!.uid,
        )
        .get();
    return UnlockedOffer.fromSnapshots(snapshot.docs);
  }

  Future<UnlockedOffer> getUnlockedOffer(String offerId) async {
    QuerySnapshot snapshot = await instance
        .collection("unlockedOffer")
        .where(
          "userId",
          isEqualTo: authInstance.currentUser!.uid,
        )
        .where(
          "offerId",
          isEqualTo: offerId,
        )
        .get();
    return UnlockedOffer.fromSnapshot(snapshot.docs[0]);
  }

  Future<void> unlockOffer(String offerId) async {
    // final url = Uri.parse('http://127.0.0.1:5001/hoora-fb944/us-central1/unlockOffer');
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://unlockoffer-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://unlockoffer-5lgw4vxlaa-uc.a.run.app');
    await http.post(
      url,
      body: {
        'offerId': offerId,
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }

  Future<void> activateUnlockedOffer(String unlockedOfferId) async {
    await instance.collection("unlockedOffer").doc(unlockedOfferId).update({
      "status": UnlockedOfferStatus.activated.name,
      "validatedAt": DateTime.now().toUtc(),
    });
  }

  Future<List<Offer>> getCityAndOnlineOffers(cityId) async {

    QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
        .collection("offer")
        .get();

    List<Offer> offers = Offer.fromSnapshots(spotSnapshot.docs);
    List<Offer> finalOffers = [];
    for(Offer offer in offers){
      if(offer.locations.isNotEmpty){
        for(OfferLocation location in offer.locations){
          if(location.cityId==cityId){
            finalOffers.add(offer);
          }
        }
      }else{
        finalOffers.add(offer);
      }
    }
    return finalOffers;
  }

  //in spot page bloc
  Future<List<Offer>> getOffersByCity(cityId) async {

    QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
        .collection("offer")
        .get();

    List<Offer> offers = Offer.fromSnapshots(spotSnapshot.docs);
    List<Offer> finalOffers = [];
    for(Offer offer in offers){
      if(offer.locations.isNotEmpty){
        for(OfferLocation location in offer.locations){
          if(location.cityId==cityId){
            finalOffers.add(offer);
          }
        }
      }
    }
    return finalOffers;
  }

  Future<CityAndOffers> getOffersBySearch(String search,regions) async{
    List<Offer> alloffers = [];
    City?  searchedCity ;
    if(search.isNotEmpty){

      for(Region region in regions){
        for(City city in region.cities){
          if(city.name.replaceAll("é", "e").replaceAll("è", "e").replaceAll("â", "a").toLowerCase().contains(search.toLowerCase())){
            debugPrint("found city name :${city.name}");
            QuerySnapshot spotSnapshot = await FirebaseFirestore.instance
                .collection("offer")
                .get();
            List<Offer> offers = Offer.fromSnapshots(spotSnapshot.docs);
            for(Offer offer in offers){
              if(offer.locations.isNotEmpty){
                for(OfferLocation location in offer.locations){
                  debugPrint("hay hay ${location.cityId}");
                  if(location.cityId==city.id){
                    alloffers.add(offer);
                  }
                }
              }
            }
            searchedCity=city;
            break;
          }
        }
      }
    }else{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("offer")
          .get();

      alloffers = Offer.fromSnapshots(snapshot.docs);
    }
    debugPrint("allSpots${alloffers.length}");

    return CityAndOffers(city: searchedCity, offers: alloffers);
  }

}
class CityAndOffers {
  City? city;
  Region? region;
  final List<Offer> offers;

  CityAndOffers({required this.city, required this.offers});
}