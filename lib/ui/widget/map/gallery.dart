import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/widget/page_indicator.dart';

class Gallery extends StatefulWidget {
  final Spot spot;
  const Gallery({super.key, required this.spot});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  PageController controller = PageController();
  int currentIndex = 0;
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    List<String> imageGalleryPaths = widget.spot.imageGalleryPaths;

    for (int i = 0; i < imageGalleryPaths.length; i++) {
      String path = imageGalleryPaths[i];
      images.add(
        FutureBuilder<String>(
          future: FirebaseStorage.instance.ref().child("spot/gallery/$path").getDownloadURL(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              BorderRadius? borderRadius;

              if (imageGalleryPaths.length > 1 && i == 0) {
                borderRadius = const BorderRadius.only(
                  topLeft: Radius.circular(kRadius20),
                  bottomLeft: Radius.circular(kRadius20),
                );
              } else if (imageGalleryPaths.length > 1 && i == imageGalleryPaths.length - 1) {
                borderRadius = const BorderRadius.only(
                  topRight: Radius.circular(kRadius20),
                  bottomRight: Radius.circular(kRadius20),
                );
              }

              return CachedNetworkImage(
                filterQuality: FilterQuality.none,
                fit: BoxFit.cover,
                imageUrl: snapshot.data!,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: kPrimary),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: images,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kPadding20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PageIndicator(
                length: widget.spot.imageGalleryPaths.length,
                currentIndex: currentIndex,
                selectedColor: Colors.white,
                unselectedColor: Colors.white.withOpacity(0.30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
