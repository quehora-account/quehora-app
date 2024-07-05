import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/organization_model.dart';

class OrganizationRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Organization>> getAllOrganizations() async {
    QuerySnapshot snapshot = await instance.collection("organization").get();
    return Organization.fromSnapshots(snapshot.docs);
  }
}
