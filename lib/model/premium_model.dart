import 'package:cloud_firestore/cloud_firestore.dart';

class BalancePremium {
  final DateTime from;
  final DateTime to;
  final int gem;

  BalancePremium({required this.from, required this.to, required this.gem});

  factory BalancePremium.fromSnapshot(QueryDocumentSnapshot doc) {
    return BalancePremium(
      from: (doc["from"] as Timestamp).toDate(),
      to: (doc["to"] as Timestamp).toDate(),
      gem: doc['gem'],
    );
  }
  factory BalancePremium.fromJson(Map<String, dynamic> json) {
    return BalancePremium(
      from: (json["from"] as Timestamp).toDate(),
      to: (json["to"] as Timestamp).toDate(),
      gem: json['gem'],
    );
  }
}

class PulsePremium {
  final DateTime from;
  final DateTime to;
  final int gem;

  PulsePremium({required this.from, required this.to, required this.gem});

  factory PulsePremium.fromSnapshot(QueryDocumentSnapshot doc) {
    return PulsePremium(
      from: (doc["from"] as Timestamp).toDate(),
      to: (doc["to"] as Timestamp).toDate(),
      gem: doc['gem'],
    );
  }

  factory PulsePremium.fromJson(Map<String, dynamic> json) {
    return PulsePremium(
      from: (json["from"] as Timestamp).toDate(),
      to: (json["to"] as Timestamp).toDate(),
      gem: json['gem'],
    );
  }
}
