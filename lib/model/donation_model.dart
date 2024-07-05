import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String id;
  final String projectId;
  final String userId;
  final int gem;
  final DateTime createdAt;

  factory Donation.fromSnapshot(QueryDocumentSnapshot doc) {
    return Donation(
      id: doc.id,
      userId: doc["userId"],
      projectId: doc["projectId"],
      gem: doc["gem"],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
    );
  }

  Donation(
      {required this.id, required this.projectId, required this.userId, required this.gem, required this.createdAt});

  static List<Donation> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Donation> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Donation.fromSnapshot(doc));
    }
    return list;
  }
}
