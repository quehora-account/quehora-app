import 'package:cloud_firestore/cloud_firestore.dart';

class LastCrowdReport {
  final String userId;
  final DateTime createdAt;
  final String duration;
  final int intensity;

  LastCrowdReport({
    required this.createdAt,
    required this.userId,
    required this.duration,
    required this.intensity,
  });

  factory LastCrowdReport.fromSnapshot(QueryDocumentSnapshot doc) {
    return LastCrowdReport(
      userId: doc['userId'],
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      duration: doc['duration'],
      intensity: doc['intensity'],
    );
  }

  static List<LastCrowdReport> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<LastCrowdReport> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(LastCrowdReport.fromSnapshot(doc));
    }
    return list;
  }

  factory LastCrowdReport.fromJson(Map<String, dynamic> json) {
    return LastCrowdReport(
      userId: json['userId'],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      duration: json['duration'],
      intensity: json['intensity'],
    );
  }

  static List<LastCrowdReport> fromJsons(List<dynamic> jsons) {
    final List<LastCrowdReport> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(LastCrowdReport.fromJson(json));
    }
    return list;
  }
}
