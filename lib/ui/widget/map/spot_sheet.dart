import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/spot_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:slider_button/slider_button.dart';
import '../../page/explore/create_crowd_report_page.dart';
import '../../page/explore/validation_success.dart';

class SpotSheet extends StatefulWidget {
  final Spot spot;
  LatLng? userPosition;
  DateTime selectedDate;
  SpotSheet({super.key,required this.selectedDate, required this.spot, this.userPosition});

  @override
  State<SpotSheet> createState() => _SpotSheetState();
}

class _SpotSheetState extends State<SpotSheet> {
  bool isInCircleRadius = false;
  bool isLoading = false;
  bool isAfter22(){
    return DateTime.now().hour > 21 || DateTime.now().hour < 7;
  }
  @override
  void initState() {
    super.initState();
    if (widget.userPosition != null) {
      isInCircleRadius = widget.spot.isInCircleRadius(widget.userPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    int crowdReportAvg = widget.spot.crowdReportAverageAt(DateTime.now());
    final awaitingTime = widget.spot.awaitingTimeAverage(DateTime.now());

    return Scaffold(
      backgroundColor:widget.spot.isClosedAt(DateTime.now()) || isAfter22()?kBackground2:widget.spot.getGemsNow() != 0
          ? kOffPeakTime
          : kFullTime,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 60,left: kPadding40),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height:100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        if (crowdReportAvg!=-1)
                          crowdReport(crowdReportAvg)
                        else
                          const SizedBox(width: 90,height: 50,),

                        if (!widget.spot.isClosedAt(DateTime.now(), onlyHour: false))
                          gemCircle(),

                        if (crowdReportAvg!=-1 && awaitingTime!='0\'' )
                          crowdWaitingTime(awaitingTime)
                        else
                          const SizedBox(width: 90,height: 50,),
                      ],),
                  ),
                  Stack(children: [
                    Container(
                      alignment: Alignment.center,
                      child: buildIso(crowdReportAvg),),
                  ]),
                  const SizedBox(height: kPadding10),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Text(
                      widget.spot.name,
                      style: kBoldARPDisplay16.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: kPadding20),
                  widget.spot.isClosedAt(DateTime.now())?Container(height: 40,): buildButtons(),
                  if (!isInCircleRadius && widget.userPosition!=null)
                    Padding(
                      padding: const EdgeInsets.only(top: kPadding10),
                      child: Text(
                        "Vous êtes à ${widget.spot.getDistance(widget.userPosition!)} du spot",
                        style: kRegularNunito14,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(children: [

        if(isAfter22())
          SizedBox(
            height: 45,
            child: Container(
              decoration: BoxDecoration(
                color: kAfterHour22,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: SvgPicture.asset("assets/svg/gem_disable.svg",height: 15,)),
                    ),
                  ),
                  Flexible(
                    child: Text("Validation impossible après 22h",
                      style: kBoldNunito16.copyWith(color: const Color(0xff5d5d5d)),
                    ),
                  ),
                ],
              ),
            ),
          )
        else if(getGems() == 0 )
          SizedBox(
            height: 45,
            child: Container(
              decoration: BoxDecoration(
                color: kFullTimeDarker,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: SvgPicture.asset("assets/svg/gem_disable.svg",height: 15,)),
                    ),
                  ),
                  Flexible(
                    child: Text("Actuellement en heure pleine",
                      style: kBoldNunito16.copyWith(color: kPrimary),
                    ),
                  ),
                ],
              ),
            ),
          )
        else if(isInCircleRadius)
          SizedBox(
            height: 45,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: SliderButton(
                width: MediaQuery.of(context).size.width,
                backgroundColor: kPrimary,
                alignLabel: const Alignment(0, 0),
                vibrationFlag: false,
                baseColor: Colors.white.withOpacity(0.5),
                action: () async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ValidationSuccessOrAlreadyPage(userPosition: widget.userPosition!, spot: widget.spot),
                    ),);
                  });
                  return false;
                },
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Je valide ma visite",
                      style: kBoldNunito16.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: SvgPicture.asset("assets/svg/gem.svg",height: 15,)),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 45,
            child: Container(
              decoration: BoxDecoration(
                color: kOffPeakTimeDarker,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: SvgPicture.asset("assets/svg/gem_disable.svg",height: 15,)),
                    ),
                  ),
                  Flexible(
                    child: Text("Rapprochez vous pour valider",
                      style: kBoldNunito16.copyWith(color: kPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: kPadding10),
        if(isInCircleRadius && !isAfter22())
          SizedBox(
            height: 45,
            child: Container(
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0,4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCrowdReportPage(
                        spot: widget.spot,
                        userPosition: widget.userPosition!,
                      ),
                    ),
                  );
                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Je partage l'affluence",
                      style: kBoldNunito16,
                    )
                  ],
                ),
              ),
            ),
          ),

      ]),
    );
  }

  Widget gemCircle() {
    return Align(
      alignment: Alignment.topCenter,
      child: widget.spot.getGemsNow() > 0 && !widget.spot.isClosedAt(DateTime.now())?Container(
        height: 69,
        width: 69,
        decoration: BoxDecoration(
          color: widget.spot.isSponsoredNow() && getGems() > 0 ? null : kPrimary,
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
              "assets/svg/gem.svg",
              height: 24,
              width: 24,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text(
                getGems().toString(),
                style: kBoldARPDisplay20.copyWith(
                  color: widget.spot.isSponsoredNow() && getGems() > 0 ? kPrimary : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ):Container(),
    );
  }

  Widget crowdWaitingTime(awaitingTime) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20,20,20,0),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: kPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Image.asset(
                  width: 18,
                  "assets/images/hour_glass_explanation_page.png",
                  height: 27,)),
          ),
          const SizedBox(height: 4,),
          SizedBox(
            width: 65,
            child: Text(
              maxLines: 2,
              "$awaitingTime\nd’attente",
              textAlign: TextAlign.center,
              style: kBoldNunito12,
            ),
          ),
        ],
      ),
    );
  }

  Widget crowdReport(crowdReportAvg) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20,20,20,0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration:  BoxDecoration(
                color: crowdReportAvg <= 5
                    ? kOffPeakTimeDarker
                    : kFullTimeDarker,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: SvgPicture.asset(
                    height: 28,
                    width: 28,
                    "assets/svg/smiley_$crowdReportAvg.svg",
                  )),
            ),
            const SizedBox(height: 4,),
            SizedBox(
              width: 65,
              child: Text(
                maxLines: 2,
                crowdReportSentences[crowdReportAvg - 1],
                textAlign: TextAlign.center,
                style: kBoldNunito12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIso(crowdReportAvg) {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        width: constraint.maxWidth * 0.6,
        height: constraint.maxWidth * 0.6,
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
                          alignment: Alignment.center,
                          children: [
                            widget.spot.isClosedAt(DateTime.now())? Container(
                              margin: EdgeInsets.only(top:constraint.maxWidth/4 ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center( child:SvgPicture.asset("assets/svg/black_lock.svg",width: 18,height: 24,),
                                    ),
                                  ),
                                  const SizedBox(height: kPadding10,),
                                  Container(
                                    padding: const EdgeInsets.all(kPadding10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all( Radius.circular(kRadius20))),
                                    child: const Text("Fermé",style: kBoldNunito16,),
                                  ),
                                ],
                              ),
                            ):Container(),

                            if (!widget.spot.isClosedAt(DateTime.now()))
                              Image.asset(
                                'assets/images/${getIntensity(widget.spot)*2}people.png',
                                height: constraint.maxWidth,
                                width: constraint.maxWidth,
                              ),
                            buildDiscoverButton(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 35,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                offset: Offset(0,3),
                blurRadius: 3,
              ),
            ],
          ),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: Text(
              "Découvrir",
              textAlign: TextAlign.center,
              style: kBoldNunito14.copyWith(color: kPrimary),
            ),
          ),
        ),
      ],
    );
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

  int getIntensity(Spot spot) {
    /// Get density
    int averageTrafficPoint = spot.calcTrafficPointUsingCrowdReport(DateTime.now());
    int trafficPoint = spot.getTrafficPointAt(DateTime.now());
    ///there is a report
    if(averageTrafficPoint!=-1){
      if(averageTrafficPoint>=0 && averageTrafficPoint<10){
        averageTrafficPoint = 10;
      }
      if(averageTrafficPoint>-10 && averageTrafficPoint<0){
        averageTrafficPoint = -10;
      }
      trafficPoint = averageTrafficPoint;
    }
    switch(trafficPoint){
      case 30:
        return 1;
      case 25:
        return 2;
      case 20:
        return 3;
      case 15:
        return 4;
      case 10:
        return 5;
      case -10:
        return 6;
      case -15:
        return 7;
      case -20:
        return 8;
      case -25:
        return 9;
      case -30:
        return 10;
    }
    return 1;
  }
}







