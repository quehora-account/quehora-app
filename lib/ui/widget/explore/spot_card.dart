import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/spot_page.dart';

class SpotCard extends StatelessWidget {
  final Spot spot;
  const SpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = context.read<ExploreBloc>().selectedDate;

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpotPage(
                spot: spot,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(kPadding10),
          child: Row(
            children: [
              FutureBuilder<String>(
                  future: FirebaseStorage.instance.ref().child("spot/card/${spot.imageCardPath}").getDownloadURL(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.fitHeight,
                        imageUrl: snapshot.data!,
                        placeholder: (context, url) => const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          height: 100,
                          width: 100,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRadius10),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      width: 100,
                    );
                  }),
              const SizedBox(width: kPadding10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding5),

                  /// ------
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: kBoldARPDisplay12.copyWith(
                            color: Colors.white, height: 1.1),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        
                      ),
                      const SizedBox(height: kPadding5),
                      Text(
                        spot.cityName,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: kRegularNunito16.copyWith(color: Colors.white),
                      ),
                      const Spacer(),

                      /// ------
                      LayoutBuilder(builder: (context, constraint) {
                        var parentSize = constraint.maxWidth;
                        return SizedBox(
                          height: 30,
                          width: constraint.maxWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: parentSize * 0.36,
                                  child: spot.hasCrowdReportAt(selectedDate)
                                      ? Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/smiley_${spot.lastCrowdReport!.intensity}.svg",
                                        height: 18,
                                      ),
                                      const SizedBox(width: kPadding5),
                                      Expanded(
                                        child: Text(
                                          crowdReportSentences[spot.lastCrowdReport!.intensity - 1],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: kRegularNunito11.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: kPadding5),
                                    ],
                                        )
                                      : Container()
                                ),
                              SizedBox(
                                  width: parentSize * 0.23,
                                  child: spot.hasCrowdReportAt(selectedDate) &&
                                          spot.isAwaitingTimeAt(selectedDate)
                                      ? Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/hour_glass.svg",
                                      height: 18,
                                    ),
                                    const SizedBox(width: kPadding5),
                                    Text(
                                      getCrowdReportAwaitingTime(),
                                      style: kRegularNunito11.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: kPadding5),
                                          ],
                                        )
                                      : Container()
                                ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: spot.isSponsoredAt(selectedDate) && spot.getGemsAt(selectedDate) > 0
                                      ? null
                                      : kGemsIndicator,
                                  borderRadius: BorderRadius.circular(kRadius100),
                                  gradient: spot.isSponsoredAt(selectedDate) && spot.getGemsAt(selectedDate) > 0
                                      ? const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(187, 177, 123, 1),
                                            Color.fromRGBO(255, 244, 188, 1),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [
                                            0,
                                            0.7,
                                          ],
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: kPadding10),
                                    Text(
                                      spot.getGemsAt(selectedDate).toString(),
                                      style: kBoldARPDisplay13,
                                    ),
                                    const SizedBox(width: kPadding5),
                                    SvgPicture.asset(
                                      "assets/svg/gem.svg",
                                      height: 15,
                                    ),
                                    const SizedBox(width: kPadding10),
                                  ],
                                ),
                                
                              ),
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getCrowdReportAwaitingTime() {
    if (spot.lastCrowdReport == null) {
      return '0\'';
    }

    int hour = int.parse(spot.lastCrowdReport!.duration.split(":")[0]);
    int minute = int.parse(spot.lastCrowdReport!.duration.split(":")[1]);

    if (hour < 1) {
      return '$minute\'';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }
}
