import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/organization_model.dart';

class Project {
  final String id;
  final String organizationId;
  final String title;
  final String subtitle;
  final String imagePath;
  final Map<String, String> descriptions;
  final int smallDonation;
  final int mediumDonation;
  final int bigDonation;
  int collected;
  final int goal;
  final DateTime from;
  final DateTime? to;

  /// For display
  Organization? organization;

  factory Project.fromSnapshot(QueryDocumentSnapshot doc) {
    return Project(
      id: doc.id,
      organizationId: doc["organizationId"],
      title: doc["title"],
      subtitle: doc["subtitle"],
      imagePath: doc["imagePath"],
      descriptions: Map<String, String>.from(doc["descriptions"]),
      smallDonation: doc["smallDonation"],
      mediumDonation: doc["mediumDonation"],
      bigDonation: doc["bigDonation"],
      collected: doc["collected"],
      goal: doc["goal"],
      from: (doc["from"] as Timestamp).toDate(),
      to: doc["to"] == null ? null : (doc["to"] as Timestamp).toDate(),
    );
  }

  Project(
      {required this.id,
      required this.organizationId,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.descriptions,
      required this.smallDonation,
      required this.mediumDonation,
      required this.bigDonation,
      required this.collected,
      required this.goal,
      required this.from,
      required this.to});

  static List<Project> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Project> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Project.fromSnapshot(doc));
    }
    return list;
  }
}
