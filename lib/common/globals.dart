import 'package:hoora/repository/map_box_service.dart';

class AppConstants {
  static const String kSSKeyFirstLaunch = "FIRST_LAUNCH";

  static Future<String> get mapIdFuture => MapBoxService().mapIdStream!.first;

  static Future<String> getMapBoxUrl() async {
    String mapId = "clvnneyyd01ks01qp8yap3v7t";
    try {
      mapId = await mapIdFuture;
    } catch (e) {
      print('Failed to load map ID: $e');
    }
    return "https://api.mapbox.com/styles/v1/devhoora/$mapId/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2aG9vcmEiLCJhIjoiY2x1bGMwcXQxMGpxNTJrbHcwMHlsb2FkMiJ9.QeSomxVwnjxWJBmmJA__FA";
  }
}
