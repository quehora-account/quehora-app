import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/company_model.dart';

class CompanyRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Company>> getAllCompanies() async {
    QuerySnapshot snapshot = await instance.collection("company").get();
    return Company.fromSnapshots(snapshot.docs);
  }
}
