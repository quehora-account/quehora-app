import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hoora/model/user_model.dart';

class UserRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<User> getUser() async {
    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await instance.collection("user").where("userId", isEqualTo: userId).get();
    return User.fromSnapshot(snapshot.docs[0]);
  }

  Future<List<User>> getAllUsers() async {
    QuerySnapshot snapshot = await instance.collection("user").get();
    List<User> users = User.fromSnapshots(snapshot.docs);
    return users;
  }

  Future<bool> isNicknameAvailable(String nickname) async {
    final snapshot = await instance.collection("user").where("nickname", isEqualTo: nickname).get();
    if (snapshot.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> setNickname(String nickname) async {
    User user = await getUser();
    await instance.collection("user").doc(user.id).update({"nickname": nickname});
  }

  String getEmail() {
    return firebase_auth.FirebaseAuth.instance.currentUser!.email!;
  }

  Future<void> updateProfile({
    required String documentId,
    required String nickname,
    required String firstname,
    required String lastname,
    required String city,
    required String country,
    required DateTime? birthday,
    required Gender gender,
  }) async {
    await instance.collection("user").doc(documentId).update({
      "nickname": nickname,
      "firstname": firstname,
      "lastname": lastname,
      "city": city,
      "country": country,
      "birthday": birthday,
      "gender": gender.name,
    });
  }
}
