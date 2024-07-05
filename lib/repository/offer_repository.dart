import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:http/http.dart' as http;

class OfferRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<List<Offer>> getOffers() async {
    QuerySnapshot snapshot = await instance.collection("offer").get();
    List<Offer> offers = Offer.fromSnapshots(snapshot.docs);
    List<Offer> filteredOffers = [];

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

  Future<List<Offer>> getAllOffers() async {
    QuerySnapshot snapshot = await instance.collection("offer").get();
    return Offer.fromSnapshots(snapshot.docs);
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
}
