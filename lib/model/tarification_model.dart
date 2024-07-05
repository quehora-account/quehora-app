class TarificationModel {
  final String price;
  final String condition;

  TarificationModel({required this.price, required this.condition});

  static fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return TarificationModel(
      price: json["price"],
      condition: json['condition'],
    );
  }
}
