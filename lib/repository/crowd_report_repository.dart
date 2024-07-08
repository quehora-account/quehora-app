import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:http/http.dart' as http;

class CrowdReportRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<void> createCrowdReport(String spotId, int intensity, String duration) async {
    // final url = Uri.parse('http://127.0.0.1:5001/hoora-fb944/us-central1/createCrowdReport');
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://createcrowdreport-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://createcrowdreport-5lgw4vxlaa-uc.a.run.app');
    await http.post(
      url,
      body: {
        'spotId': spotId,
        'intensity': intensity.toString(),
        'duration': duration
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }

  Future<bool> crowdReportAlreadyCreated(String spotId) async {
    QuerySnapshot snapshot = await instance
        .collection("crowdReport")
        .where("spotId", isEqualTo: spotId)
        .where("userId", isEqualTo: authInstance.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    DateTime createdAt = (snapshot.docs[0]["createdAt"] as Timestamp).toDate();
    DateTime end = DateTime.now().subtract(const Duration(hours: 2));

    return !createdAt.isBefore(end);
  }
}
