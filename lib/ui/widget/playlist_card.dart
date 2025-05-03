import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/playlist_model.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final void Function(Playlist) onTap;
  final Playlist? selectedPlaylist;
  const PlaylistCard({super.key, required this.playlist, required this.onTap, required this.selectedPlaylist});

  @override
  Widget build(BuildContext context) {
    String path = "";
    if(selectedPlaylist != null && playlist.id == selectedPlaylist!.id){
      path = "playlist/${playlist.imagePath}";
    }else{
      path = "playlist/${playlist.imageGreen}";
    }
    return SizedBox(
      height: 40,
      width: 45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadius10),
          onTap: () {
            onTap(playlist);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                  future: FirebaseStorage.instance.ref().child(path).getDownloadURL(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl: snapshot.data!,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Container(),
                        ),
                      );
                    }
                    return const Spacer();
                  }),
              const SizedBox(height: 2.5),
              Text(
                playlist.name,
                style: kRegularNunito10.copyWith(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
