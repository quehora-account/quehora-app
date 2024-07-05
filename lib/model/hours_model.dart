class Hours {
  final String start;
  final String end;

  Hours({required this.start, required this.end});

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      start: json["start"],
      end: json["end"],
    );
  }

  static List<Hours> fromJsons(List<dynamic> jsons) {
    final List<Hours> list = [];
    for (Map<String, dynamic> json in jsons) {
      list.add(Hours.fromJson(json));
    }
    return list;
  }
}
