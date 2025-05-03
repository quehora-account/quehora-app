import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/super_type_model.dart';

class SuperTypeRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<SuperType>> getAllSuperTypes() async {
    QuerySnapshot snapshot = await instance.collection("superType").get();
    return SuperType.fromSnapshots(snapshot.docs);
  }
}
