import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

class SpotCard extends StatelessWidget {
  final Spot spot;

  const SpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = context.read<ExploreBloc>().selectedDate;
    final crowdReportAvg = spot.crowdReportAverageAt(selectedDate);
    final awaitingTime = spot.awaitingTimeAverage(selectedDate);
    return Container(
      width: double.infinity,
      decoration:  const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 4),
            blurRadius: 3.8,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(kRadius10) ),
      ),
      child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 160,
              child: FutureBuilder<String>(
                  future: FirebaseStorage.instance
                      .ref()
                      .child("spot/card/${spot.imageCardPath}")
                      .getDownloadURL(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          CachedNetworkImage(
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            imageUrl: snapshot.data!,
                            placeholder: (context, url) => const SizedBox(
                              height: 160,
                              width: 100,
                            ),
                            errorWidget: (context, url, error) =>
                            const SizedBox(
                              height: 160,
                              width: 100,
                            ),
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(kRadius10)),
                                    image: DecorationImage( image: imageProvider, fit: BoxFit.fitWidth),
                                  ),
                                ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: spot.isClosedAt(selectedDate)? Container(
                              width: 80,
                              margin: const EdgeInsets.all(kPadding10),
                              padding: const EdgeInsets.all(kPadding5),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(kRadius20))),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/svg/black_lock.svg",width: 16,height: 16,),
                                  Text("Fermé",style: kRegularNunito14.copyWith(fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ) :Container(
                              width: 120,
                              margin: const EdgeInsets.all(kPadding10),
                              padding: const EdgeInsets.all(kPadding5),
                              decoration: BoxDecoration(
                                  color: spot.getGemsAt(selectedDate) != 0
                                      ? kOffPeakTime
                                      : kFullTime,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(kRadius20))),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(size: 16, Icons.timer_sharp),
                                  Text(
                                    spot.getGemsAt(selectedDate) == 0
                                        ? "Heure pleine"
                                        : "Heure creuse",
                                    style: kRegularNunito14.copyWith(fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:crowdReportAvg!=-1?Container(
                              color: const Color(0xccffffff),
                              height: 30,
                              width: double.infinity,
                              padding:const EdgeInsets.symmetric(horizontal: kPadding10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  crowdReportAvg!=-1
                                      ? Flexible(
                                    child: Row(
                                      children: [
                                        const SizedBox( width: kPadding5),
                                        Text(
                                          "En ce moment : ",
                                          overflow:TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: kRegularNunito12.copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontSize: MediaQuery.of(context).size.width*.03
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/svg/smiley_$crowdReportAvg.svg",
                                          height: 18,
                                        ),
                                        const SizedBox(width: kPadding5),
                                        Flexible(
                                          child: Text(
                                            crowdReportSentences[crowdReportAvg -1],
                                            overflow:TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: kBoldNunito12.copyWith(fontSize: MediaQuery.of(context).size.width*.03),
                                          ),
                                        ),
                                        const SizedBox(width: kPadding5),
                                      ],
                                    ),
                                  )
                                      : Container(),
                                  crowdReportAvg!=-1 && awaitingTime!='0\'' ? Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/hour_glass.png",
                                        height: 18,
                                      ),
                                      const SizedBox(
                                          width: kPadding5),
                                      Text(
                                        "$awaitingTime d’attente",
                                        style: kBoldNunito12.copyWith(fontSize: MediaQuery.of(context).size.width*.03),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ],
                              ),
                            ):Container(),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(kPadding15,kPadding5,kPadding15,kPadding5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          spot.name,
                          style: kBoldARPDisplay13.copyWith(height: 1.1),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2,),
                        Text(
                          spot.cityName,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: kRegularNunito14.copyWith(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kPadding20,),
                  spot.getGemsAt(selectedDate) > 0 && !spot.isClosedAt(selectedDate)
                      ? Container(
                    height: 30,
                    width: 67,
                    decoration: BoxDecoration(
                      color: spot.isSponsoredAt(selectedDate) &&
                          spot.getGemsAt(selectedDate) > 0
                          ? null
                          : kBlackGreen,
                      borderRadius: BorderRadius.circular(kRadius100),
                      gradient: spot.isSponsoredAt(selectedDate) &&
                          spot.getGemsAt(selectedDate) > 0
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          spot.getGemsAt(selectedDate).toString(),
                          style: kBoldARPDisplay13.copyWith( color: spot.isSponsoredAt(selectedDate) && spot.getGemsAt(selectedDate) > 0?kPrimary:Colors.white),
                        ),
                        SvgPicture.asset(
                          "assets/svg/gem.svg",
                          height: 15,
                        ),
                      ],
                    ),
                  )
                      : Container(
                    width: 67,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
