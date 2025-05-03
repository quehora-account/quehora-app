import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:http/http.dart' as http;

import '../model/last_crowd_report_model.dart';

class CrowdReportRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<bool> createCrowdReport(
      String spotId, int intensity, String duration, List coordinates) async {
    debugPrint("createcrowdreport");
    // final url = Uri.parse('http://127.0.0.1:5001/hoora-fb944/us-central1/createCrowdReport');
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://createcrowdreport-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://createcrowdreport-5lgw4vxlaa-uc.a.run.app');
     var a = await http.post(
      url,
      body: {
        'spotId': spotId,
        'intensity': intensity.toString(),
        'duration': duration,
        'coordinates': coordinates.toString(),
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
    debugPrint("createcrowdreport${a.statusCode} body:${a.body}");
     if(!a.body.contains("error")){
       return true;
     }
    return false;
  }

  Future<bool> crowdReportAlreadyCreated(String spotId) async {
    var doc = await instance
        .collection("spot")
        .doc(spotId).get();

    var allCrowdReports =  doc.data().toString().contains('allCrowdReports') ? List<LastCrowdReport>.from(doc["allCrowdReports"].map((j) {
      LastCrowdReport to = LastCrowdReport.fromJson(j);
      return to;
    })) : [];
    for(int i = allCrowdReports.length-1;i>=0;i--){
      var report = allCrowdReports[i];
      if(report.userId==authInstance.currentUser!.uid){
        DateTime createdAt = report.createdAt;
        DateTime end = DateTime.now().subtract(const Duration(hours: 1));
        return !createdAt.isBefore(end);
      }
    }
    return false;
  }
}
