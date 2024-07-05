import 'package:hoora/model/hours_model.dart';

class OpenHours {
  final List<Hours> hours;

  OpenHours({required this.hours});

  factory OpenHours.fromJson(Map<String, dynamic> json) {
    return OpenHours(
      hours: Hours.fromJsons(json["hours"]),
    );
  }

  static List<OpenHours> fromJsons(List<dynamic> jsons) {
    final List<OpenHours> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(OpenHours.fromJson(json));
    }
    return list;
  }
}
