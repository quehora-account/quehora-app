import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/local_storage.dart';

class SuperType {
  final String id;
  final String name;
  final String image;
  final List<String> types;

  /// Initialized in the user bloc.
  static late List<SuperType> levels;
  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "image": image,
      "name": name,
      "types": types,
    };
  }
  SuperType.fromJson(Map<String , dynamic> json) :
        id = json.containsKey('id') ? json['id'] : '',
        name = json.containsKey('name') ? json['name'] ?? '' : '',
        types = json.containsKey('types')? LocalStorage.jsonArrayToList<String>(json['types'] as List, (item)=>item): [],
        image = json.containsKey('imageCode') ? json['imageCode'] ?? '' : '';

  factory SuperType.fromSnapshot(QueryDocumentSnapshot doc) {
    return SuperType(
      id: doc.id,
      name: doc['name'],
      image: doc['imageCode'],
      types:LocalStorage.jsonArrayToList<String>(doc['types'] as List, (item)=>item),
    );
  }

  SuperType(
      {required this.id,
        required this.name,
        required this.image,
        required this.types,
      });

  static List<SuperType> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<SuperType> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(SuperType.fromSnapshot(doc));
    }
    return list;
  }
}
