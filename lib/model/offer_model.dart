import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/company_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';

// ignore: constant_identifier_names
enum CodeType { reference, single_use }

class Offer {
  final String id;
  final String cityId;
  final String companyId;
  final String imagePath;
  final List<String> codes;
  final CodeType codeType;
  final Map<String, String> conditions;
  final String description;
  final List<String> instructions;
  final DateTime from;
  final DateTime? to;
  final int levelRequired;
  final int price;
  final int priority;
  final String title;
  Company? company;

  /// For display
  UnlockedOffer? unlockedOffer;

  Offer({
    required this.id,
    required this.cityId,
    required this.companyId,
    required this.imagePath,
    required this.codes,
    required this.codeType,
    required this.conditions,
    required this.description,
    required this.instructions,
    required this.from,
    required this.to,
    required this.levelRequired,
    required this.price,
    required this.priority,
    required this.title,
  });

  factory Offer.fromSnapshot(QueryDocumentSnapshot doc) {
    return Offer(
      id: doc.id,
      cityId: doc["cityId"],
      companyId: doc["companyId"],
      imagePath: doc["imagePath"],
      codes: List<String>.from(doc["codes"]),
      codeType: CodeType.values.byName(doc["codeType"]),
      conditions: Map<String, String>.from(doc["conditions"]),
      description: doc["description"],
      instructions: List<String>.from(doc["instructions"]),
      from: (doc["from"] as Timestamp).toDate(),
      to: doc["to"] == null ? null : (doc["to"] as Timestamp).toDate(),
      levelRequired: doc["levelRequired"],
      price: doc["price"],
      priority: doc["priority"],
      title: doc["title"],
    );
  }

  static List<Offer> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Offer> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Offer.fromSnapshot(doc));
    }
    return list;
  }
}
