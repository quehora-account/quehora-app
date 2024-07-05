import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/level_model.dart';

enum Gender { male, female, other }

class User {
  final String id;
  final String userId;
  int gem;
  final int experience;
  final int level;
  String firstname;
  String lastname;
  String nickname;
  String city;
  String country;
  Gender? gender;
  DateTime? birthday;
  final int amountSpotValidated;
  final int amountCrowdReportCreated;
  final int amountChallengeUnlocked;
  final int amountOfferUnlocked;
  final int amountDonation;
  final DateTime createdAt;

  User({
    required this.id,
    required this.userId,
    required this.gem,
    required this.experience,
    required this.level,
    required this.firstname,
    required this.lastname,
    required this.nickname,
    required this.city,
    required this.country,
    required this.gender,
    required this.birthday,
    required this.createdAt,
    required this.amountChallengeUnlocked,
    required this.amountCrowdReportCreated,
    required this.amountDonation,
    required this.amountOfferUnlocked,
    required this.amountSpotValidated,
  });

  factory User.fromSnapshot(QueryDocumentSnapshot doc) {
    return User(
      id: doc.id,
      userId: doc["userId"],
      gem: doc['gem'],
      experience: doc['experience'],
      level: Level.getLevelFromExperience(doc['experience'] as int),
      firstname: doc['firstname'],
      lastname: doc['lastname'],
      nickname: doc['nickname'],
      city: doc['city'],
      country: doc['country'],
      gender: doc['gender'] == null ? null : Gender.values.byName(doc['gender']),
      birthday: doc["birthday"] == null ? null : (doc["birthday"] as Timestamp).toDate(),
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      amountChallengeUnlocked: doc['amountChallengeUnlocked'],
      amountCrowdReportCreated: doc['amountCrowdReportCreated'],
      amountDonation: doc['amountDonation'],
      amountOfferUnlocked: doc['amountOfferUnlocked'],
      amountSpotValidated: doc['amountSpotValidated'],
    );
  }

  static List<User> fromSnapshots(List<QueryDocumentSnapshot> docs) {
    final List<User> list = [];
    for (QueryDocumentSnapshot doc in docs) {
      list.add(User.fromSnapshot(doc));
    }
    return list;
  }
}
