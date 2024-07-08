import 'package:cloud_firestore/cloud_firestore.dart';

class AppConstants {
  static const String kSSKeyFirstLaunch = "FIRST_LAUNCH";

  static Future<String> getMapBoxUrl() async {
    var mapId = await FirebaseFirestore.instance
        .collection('constant') // Remplacez par le nom de votre collection
        .doc('activeMapBox')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get('url');
      } else {
        return 'clulcc0x700le01nt1509c14f'; // Valeur par défaut si le document n'existe pas
      }
    });

    return "https://api.mapbox.com/styles/v1/devhoora/$mapId/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2aG9vcmEiLCJhIjoiY2x1bGMwcXQxMGpxNTJrbHcwMHlsb2FkMiJ9.QeSomxVwnjxWJBmmJA__FA";

  }

}
