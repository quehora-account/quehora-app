import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/level_model.dart';

class LevelRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Level>> getAllLevels() async {
    QuerySnapshot snapshot = await instance.collection("level").get();
    return Level.fromSnapshots(snapshot.docs);
  }
}
