import {CreatePlaylistDto} from "../common/dto/create_playlist.dto";
import * as admin from "firebase-admin";
import {PlaylistEntity} from "../common/entity/playlist.entity";

export class PlaylistService {
  static async create(dto: CreatePlaylistDto) : Promise<void> {
    await admin.firestore().collection("playlist").add(dto.toJson());
  }

  static async getAll() : Promise<PlaylistEntity[]> {
    const snapshot = await admin.firestore().collection("playlist").get();
    const playlists = PlaylistEntity.fromSnapshots(snapshot.docs);
    return playlists;
  }
}
