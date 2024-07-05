import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/region_model.dart';

class RegionRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Region>> getAllRegions() async {
    QuerySnapshot snapshot = await instance.collection("region").get();
    return Region.fromSnapshots(snapshot.docs);
  }
}
