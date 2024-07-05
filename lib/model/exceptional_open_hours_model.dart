import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/hours_model.dart';

class ExceptionalOpenHours {
  final DateTime date;
  final List<Hours> hours;

  factory ExceptionalOpenHours.fromJson(Map<String, dynamic> json) {
    return ExceptionalOpenHours(
      date: (json["date"] as Timestamp).toDate(),
      hours: Hours.fromJsons(json["hours"]),
    );
  }

  static List<ExceptionalOpenHours> fromJsons(List<dynamic> jsons) {
    final List<ExceptionalOpenHours> hour = [];
    for (Map<String, dynamic> json in jsons) {
      hour.add(ExceptionalOpenHours.fromJson(json));
    }
    return hour;
  }

  ExceptionalOpenHours({required this.date, required this.hours});
}
