import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/common/active_flavor.dart';
import 'package:hoora/common/flavors.dart';
import 'package:hoora/model/donation_model.dart';
import 'package:hoora/model/project_model.dart';
import 'package:http/http.dart' as http;

class ProjectRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<List<Project>> getAllProjects() async {
    QuerySnapshot snapshot = await instance.collection("project").get();
    List<Project> projects = Project.fromSnapshots(snapshot.docs);
    List<Project> filteredProjects = [];

    for (Project project in projects) {
      if (project.from.isAfter(DateTime.now())) {
        continue;
      }

      if (project.to != null && project.to!.isBefore(DateTime.now())) {
        continue;
      }

      filteredProjects.add(project);
    }
    return filteredProjects;
  }

  Future<List<Donation>> getDonations() async {
    QuerySnapshot snapshot = await instance
        .collection("donation")
        .where(
          "userId",
          isEqualTo: authInstance.currentUser!.uid,
        )
        .get();
    return Donation.fromSnapshots(snapshot.docs);
  }

  Future<void> createDonation(String projectId, int gem) async {
    // final url = Uri.parse('http://127.0.0.1:5001/hoora-fb944/us-central1/donate');
    final url = QuehoraActiveFlavor.activeFlavor == Flavor.production
        ? Uri.parse('https://donate-nmciz2db3a-uc.a.run.app')
        : Uri.parse('https://donate-5lgw4vxlaa-uc.a.run.app');
    await http.post(
      url,
      body: {
        'projectId': projectId,
        'gem': "$gem",
      },
      headers: {
        "authorization": "Bearer ${await authInstance.currentUser!.getIdToken()}",
      },
    );
  }

  Future<Donation> getDonation(String projectId) async {
    QuerySnapshot snapshot = await instance
        .collection("donation")
        .where(
          "userId",
          isEqualTo: authInstance.currentUser!.uid,
        )
        .where(
          "projectId",
          isEqualTo: projectId,
        )
        .get();
    return Donation.fromSnapshot(snapshot.docs[0]);
  }
}
