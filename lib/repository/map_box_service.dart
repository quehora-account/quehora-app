import 'package:cloud_firestore/cloud_firestore.dart';

class MapBoxService {
  static final MapBoxService _instance = MapBoxService._internal();
  Stream<String>? mapIdStream;

  factory MapBoxService() {
    return _instance;
  }

  MapBoxService._internal() {
    _init();
  }

  void _init() {
    mapIdStream = FirebaseFirestore.instance
        .collection('constant') // Remplacez par le nom de votre collection
        .doc('activeMapBox')
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get('url');
      } else {
        return 'default_map_id'; // Valeur par défaut si le document n'existe pas
      }
    });
  }
}
