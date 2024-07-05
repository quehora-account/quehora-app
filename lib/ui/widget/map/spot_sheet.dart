import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/map/create_crowd_report_page.dart';
import 'package:hoora/ui/page/spot_page.dart';
import 'package:hoora/ui/page/map/spot_validation_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:slider_button/slider_button.dart';

class SpotSheet extends StatefulWidget {
  final Spot spot;
  final LatLng? userPosition;
  const SpotSheet({super.key, required this.spot, required this.userPosition});

  @override
  State<SpotSheet> createState() => _SpotSheetState();
}

class _SpotSheetState extends State<SpotSheet> {
  bool isInCircleRadius = false;

  @override
  void initState() {
    super.initState();
    if (widget.userPosition != null) {
      isInCircleRadius = widget.spot.isInCircleRadius(widget.userPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: kPadding5),
          child: Text(
            "Affluences signalées il y a moins de deux heures.",
            style: kRegularNunito12.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isInCircleRadius ? kSecondary : kPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kRadius20),
              topRight: Radius.circular(kRadius20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              children: [
                if (!widget.spot.isClosedAt(DateTime.now(), onlyHour: false)) buildCircles(),
                buildIso(),
                buildDiscoverButton(),
                const SizedBox(height: kPadding10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Text(
                    widget.spot.name,
                    style: kBoldARPDisplay16.copyWith(
                      color: isInCircleRadius ? kPrimary : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kPadding40),
                buildButtons(),
                if (!isInCircleRadius)
                  Padding(
                    padding: const EdgeInsets.only(top: kPadding10),
                    child: Text(
                      "Rapprochez vous du site pour pouvoir valider",
                      style: kRegularNunito14.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Column(children: [
      SizedBox(
        height: 50,
        child: Stack(
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCrowdReportPage(
                        spot: widget.spot,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Je partage l'affluence",
                      style: kBoldNunito16,
                    ),
                    const SizedBox(width: kPadding10),
                    SvgPicture.asset("assets/svg/gem.svg"),
                  ],
                ),
              ),
            ),
            if (!isInCircleRadius || widget.spot.isClosedAt(DateTime.now()))
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(kRadius100),
                ),
              )
          ],
        ),
      ),
      const SizedBox(height: kPadding10),
      SizedBox(
        height: 50,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: LayoutBuilder(builder: (_, constraint) {
                  /// 25 the half of the button size with his padding (55/50 total)
                  return SliderButton(
                    width: constraint.maxWidth + 25,
                    backgroundColor: kPrimary,
                    alignLabel: const Alignment(0, 0),
                    shimmer: false,
                    vibrationFlag: false,
                    action: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpotValidationPage(
                            spot: widget.spot,
                          ),
                        ),
                      );
                      return false;
                    },
                    label: Padding(
                      /// 35 the button size
                      padding: const EdgeInsets.only(left: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Je valide ma visite",
                            style: kBoldNunito16.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: kPadding10),
                          SvgPicture.asset("assets/svg/gem.svg"),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          CupertinoIcons.arrow_right,
                          color: kPrimary,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (!isInCircleRadius || getGems() == 0 || widget.spot.isClosedAt(DateTime.now(), onlyHour: false))
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(kRadius100),
                ),
              )
          ],
        ),
      ),
    ]);
  }

  Widget buildCircles() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Crowd

        if (widget.spot.hasCrowdReportNow())
          SizedBox(
            width: 75,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(kRadius100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        width: 2.5,
                        color: Colors.white,
                      )),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(kPadding10),
                    child: SvgPicture.asset(
                      "assets/svg/smiley_${widget.spot.lastCrowdReport!.intensity}.svg",
                    ),
                  )),
                ),
                const SizedBox(height: kPadding5),
                Text(
                  crowdReportSentences[widget.spot.lastCrowdReport!.intensity - 1],
                  style: kRegularNunito12.copyWith(color: isInCircleRadius ? kPrimary : kPrimary3),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        const Spacer(),

        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              /// Text
              SizedBox(
                height: 30,
                child: Text(
                  getHourText(),
                  style: kRegularNunito12.copyWith(color: isInCircleRadius ? kPrimary : Colors.white),
                ),
              ),

              /// Gem
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRadius100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: widget.spot.isSponsoredNow() && getGems() > 0 ? null : kPrimary,
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(kRadius100),
                    gradient: widget.spot.isSponsoredNow() && getGems() > 0
                        ? const LinearGradient(
                            colors: [
                              Color.fromRGBO(187, 177, 123, 1),
                              Color.fromRGBO(255, 244, 188, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                              0,
                              0.7,
                            ],
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        getGems() == 0 ? "assets/svg/grey_gem.svg" : "assets/svg/gem.svg",
                        height: 17,
                      ),
                      const SizedBox(height: 1),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          getGems().toString(),
                          style: kBoldARPDisplay11.copyWith(
                            color: widget.spot.isSponsoredNow() && getGems() > 0 ? kPrimary : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // Reports
        if (widget.spot.hasCrowdReportNow())
          SizedBox(
            width: 75,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(kRadius100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        width: 2.5,
                        color: Colors.white,
                      )),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(kPadding10),
                    child: SvgPicture.asset("assets/svg/hour_glass.svg"),
                  )),
                ),
                const SizedBox(height: kPadding5),
                Text(
                  getCrowdReportAwaitingTimeSentence(),
                  style: kRegularNunito12.copyWith(
                    color: isInCircleRadius ? kPrimary : kPrimary3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildIso() {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        height: constraint.maxWidth * 0.6,
        width: constraint.maxWidth * 0.6,
        child: FutureBuilder<String>(
            future: FirebaseStorage.instance.ref().child("spot/iso/${widget.spot.imageIsoPath}").getDownloadURL(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                  imageBuilder: (context, imageProvider) => LayoutBuilder(builder: (_, constraint) {
                    return Container(
                        width: constraint.maxWidth,
                        constraints: BoxConstraints(
                          maxWidth: constraint.maxWidth,
                          maxHeight: constraint.maxWidth,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (widget.spot.isClosedAt(DateTime.now(), onlyHour: false))
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    SvgPicture.asset(
                                      "assets/svg/lock.svg",
                                      height: 30,
                                    ),
                                    const SizedBox(height: kPadding10),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            kRadius100,
                                          )),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: kPadding10, vertical: kPadding5),
                                        child: Text(
                                          "Fermé",
                                          style: kRegularNunito16,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            if (!widget.spot.isClosedAt(DateTime.now(), onlyHour: false) &&
                                widget.spot.hasCrowdReportNow() &&
                                widget.spot.lastCrowdReport!.intensity > 1)
                              Image.asset(
                                'assets/images/intensity_${widget.spot.lastCrowdReport!.intensity}.png',
                                height: constraint.maxWidth,
                                width: constraint.maxWidth,
                              )
                          ],
                        ));
                  }),
                );
              }
              return LayoutBuilder(builder: (_, constraint) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: constraint.maxWidth,
                    maxHeight: constraint.maxWidth,
                  ),
                );
              });
            }),
      );
    });
  }

  Widget buildDiscoverButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 130,
            height: 35,
            child: ElevatedButton(
              onPressed: () async {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpotPage(
                      spot: widget.spot,
                    ),
                  ),
                );
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimary3),
              child: Text(
                "Découvrir",
                style: kBoldNunito14.copyWith(color: kPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCrowdReportAwaitingTimeSentence() {
    if (widget.spot.lastCrowdReport == null) {
      return '0\'';
    }

    if (!widget.spot.isAwaitingTimeNow()) {
      return "Pas d'attente signalée";
    }

    int hour = int.parse(widget.spot.lastCrowdReport!.duration.split(":")[0]);
    int minute = int.parse(widget.spot.lastCrowdReport!.duration.split(":")[1]);

    if (hour < 1) {
      return "$minute min. d'attente";
    }

    if (minute < 15) {
      return "$hour h d'attente";
    }

    return "${hour}h$minute d'attente";
  }

  int getGems() {
    if (DateTime.now().hour > 21 || DateTime.now().hour < 7) {
      return 0;
    }
    return widget.spot.getGemsNow();
  }

  String getHourText() {
    if (DateTime.now().hour < 7 || DateTime.now().hour > 21) {
      return "";
    }
    if (widget.spot.getGemsNow() == 0) {
      return "heure pleine";
    }
    return "heure creuse";
  }
}
