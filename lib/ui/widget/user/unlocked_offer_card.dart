import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/widget/user/unlocked_offer_sheet.dart';

class UnlockedOfferCard extends StatelessWidget {
  final Offer offer;
  const UnlockedOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return UnlockedOfferSheet(offer: offer);
          },
        );
      },
      child: Container(
        height: 160,
        width: getWidth(context),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(kRadius10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            /// Offer picture
            SizedBox(
              height: 100,
              width: getWidth(context),
              child: getOfferImage(),
            ),

            /// Informations
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kPadding10),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: getCompanyImage(),
                    ),
                    const SizedBox(width: kPadding10),
                    SizedBox(
                      width: getWidth(context) - (30 + 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.company!.name,
                            style: kBoldARPDisplay14,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: kPadding5),
                          Text(
                            offer.title,
                            style: kRegularNunito14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width - 40);
  }

  Widget getOfferImage() {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("offer/${offer.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: snapshot.data!,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
              imageBuilder: (context, imageProvider) => LayoutBuilder(builder: (_, constraint) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kRadius10),
                      topRight: Radius.circular(kRadius10),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            );
          }
          return const SizedBox();
        });
  }

  Widget getCompanyImage() {
    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("company/${offer.company!.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: snapshot.data!,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
            );
          }
          return const SizedBox();
        });
  }
}
