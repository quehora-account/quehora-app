import 'package:cloud_firestore/cloud_firestore.dart';

class Playlist {
  final String id;
  final String name;
  final String imagePath;
  final int priority;

  Playlist({required this.id, required this.name, required this.imagePath, required this.priority});

  factory Playlist.fromSnapshot(QueryDocumentSnapshot doc) {
    return Playlist(
      id: doc.id,
      name: doc['name'],
      imagePath: doc['imagePath'],
      priority: doc['priority'],
    );
  }

  static List<Playlist> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Playlist> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Playlist.fromSnapshot(doc));
    }
    return list;
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json["id"],
      name: json['name'],
      imagePath: json['imagePath'],
      priority: json['priority'],
    );
  }

  static List<Playlist> fromJsons(List<dynamic> jsons) {
    final List<Playlist> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(Playlist.fromJson(json));
    }
    return list;
  }
}
