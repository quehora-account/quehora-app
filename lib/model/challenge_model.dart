import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoora/model/unlocked_challenge_model.dart';

class Challenge {
  final String id;
  final String imagePath;
  final String name;
  final String description;
  final List<int> backgroundColor;
  final List<int> textColor;
  final int gem;
  final int priority;
  final DateTime from;
  final DateTime? to;

  /// To facilitate UI usage.
  UnlockedChallenge? unlockedChallenge;

  Challenge({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    required this.gem,
    required this.priority,
    required this.from,
    required this.to,
  });

  Color getBackgroundColor() => Color.fromRGBO(backgroundColor[0], backgroundColor[1], backgroundColor[2], 1);
  Color getTextColor() => Color.fromRGBO(textColor[0], textColor[1], textColor[2], 1);

  factory Challenge.fromSnapshot(QueryDocumentSnapshot doc) {
    return Challenge(
      id: doc.id,
      name: doc['name'],
      imagePath: doc['imagePath'],
      description: doc['description'],
      backgroundColor: List<int>.from(doc['backgroundColor']),
      textColor: List<int>.from(doc['textColor']),
      gem: doc['gem'],
      priority: doc['priority'],
      from: (doc['from'] as Timestamp).toDate(),
      to: doc['to'] == null ? null : (doc['to'] as Timestamp).toDate(),
    );
  }

  static List<Challenge> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<Challenge> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(Challenge.fromSnapshot(doc));
    }
    return list;
  }
}
