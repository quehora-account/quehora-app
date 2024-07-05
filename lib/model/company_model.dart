import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String cityId;
  final String imagePath;
  final String name;

  Company({
    required this.id,
    required this.cityId,
    required this.name,
    required this.imagePath,
  });

  factory Company.fromSnapshot(QueryDocumentSnapshot doc) {
    return Company(
      id: doc.id,
      cityId: doc["cityId"],
      name: doc["name"],
      imagePath: doc["imagePath"],
    );
  }

  static List<Company> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Company> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Company.fromSnapshot(doc));
    }
    return list;
  }
}
