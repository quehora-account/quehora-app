import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/ui/page/offer/offer_page.dart';
import 'package:hoora/model/level_model.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    bool canBeUnlocked = context.read<UserBloc>().user.level >= offer.levelRequired;

    return InkWell(
      onTap: canBeUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OfferPage(offer: offer),
                ),
              );
            }
          : null,
      child: Container(
        height: 170,
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
        child: Stack(
          children: [
            Column(
              children: [
                /// Offer picture
                SizedBox(
                  height: 100,
                  width: getWidth(context),
                  child: Stack(
                    children: [
                      getOfferImage(),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(kPadding10),
                          child: buildPrice(),
                        ),
                      ),
                    ],
                  ),
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
                          /// 30 padding and 40 image
                          width: getWidth(context) - (30 + 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.company!.name,
                                style: kBoldARPDisplay14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: kPadding5),
                              Text(
                                offer.title,
                                maxLines: 1,
                                style: kRegularNunito14,
                                overflow: TextOverflow.ellipsis,
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
            if (!canBeUnlocked)
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(kRadius10),
                ),
                child: Center(
                  child: getLevelSvg(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildPrice() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: kPadding10),
          Text(
            offer.price.toString(),
            style: kBoldARPDisplay13.copyWith(color: Colors.white),
          ),
          const SizedBox(width: kPadding5),
          SvgPicture.asset(
            "assets/svg/gem.svg",
            height: 15,
          ),
          const SizedBox(width: kPadding10),
        ],
      ),
    );
  }

  double getWidth(BuildContext context) {
    // 40 = kPadding * 2 (left and right)
    return (MediaQuery.of(context).size.width - 40) * 0.8;
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

  Widget getLevelSvg() {
    Level level = Level.getLevel(offer.levelRequired);

    return FutureBuilder<String>(
        future: FirebaseStorage.instance.ref().child("level/${level.imagePath}").getDownloadURL(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.network(
              snapshot.data!,
              height: 60,
            );
          }
          return const SizedBox();
        });
  }
}
