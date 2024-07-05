import 'package:cloud_firestore/cloud_firestore.dart';

enum UnlockedOfferStatus { unlocked, activated }

class UnlockedOffer {
  final String id;
  final String offerId;
  final String userId;
  final String code;
  UnlockedOfferStatus status;
  final int gem;
  final DateTime createdAt;
  DateTime? validatedAt;

  UnlockedOffer({
    required this.id,
    required this.offerId,
    required this.userId,
    required this.code,
    required this.status,
    required this.gem,
    required this.createdAt,
    required this.validatedAt,
  });

  factory UnlockedOffer.fromSnapshot(QueryDocumentSnapshot doc) {
    return UnlockedOffer(
      id: doc.id,
      offerId: doc["offerId"],
      userId: doc["userId"],
      code: doc["code"],
      status: UnlockedOfferStatus.values.byName(doc["status"]),
      gem: doc["gem"],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      validatedAt: doc["validatedAt"] == null ? null : (doc["validatedAt"] as Timestamp).toDate(),
    );
  }

  static List<UnlockedOffer> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<UnlockedOffer> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(UnlockedOffer.fromSnapshot(doc));
    }
    return list;
  }
}
