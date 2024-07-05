import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoora/model/playlist_model.dart';

class PlaylistRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<List<Playlist>> getPlaylists() async {
    QuerySnapshot snapshot = await instance.collection("playlist").get();
    return Playlist.fromSnapshots(snapshot.docs);
  }
}
