// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType {
  validation,
  crowd_report,
  launch_gift,
  challenge,
  offer,
  donation,
}

class Transaction {
  final String id;
  final String userId;
  final String name;
  TransactionType type;
  final int gem;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.gem,
    required this.createdAt,
    required this.name,
    required this.type,
  });

  factory Transaction.fromSnapshot(QueryDocumentSnapshot doc) {
    return Transaction(
      id: doc.id,
      name: doc["name"],
      userId: doc["userId"],
      type: TransactionType.values.byName(doc["type"]),
      gem: doc["gem"],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
    );
  }

  static List<Transaction> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Transaction> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Transaction.fromSnapshot(doc));
    }
    return list;
  }
}
