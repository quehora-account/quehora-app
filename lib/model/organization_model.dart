import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String id;
  final String imagePath;
  final String name;

  Organization({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory Organization.fromSnapshot(QueryDocumentSnapshot doc) {
    return Organization(
      id: doc.id,
      name: doc["name"],
      imagePath: doc["imagePath"],
    );
  }

  static List<Organization> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Organization> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Organization.fromSnapshot(doc));
    }
    return list;
  }
}
