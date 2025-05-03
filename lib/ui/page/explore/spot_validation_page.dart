import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/globals.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/explore/create_crowd_report_page.dart';
import 'package:hoora/ui/page/explore/validation_success.dart';
import 'package:latlong2/latlong.dart';
import 'package:slider_button/slider_button.dart';

import '../../../common/sentences.dart';

class SpotValidationPage extends StatefulWidget {
  final List<Spot> spots;
  final LatLng userPosition;
  bool fromLoadingPage = false;

   SpotValidationPage({super.key, required this.spots, required this.userPosition,this.fromLoadingPage = false});

  @override
  State<SpotValidationPage> createState() => _SpotValidationPageState();
}

class _SpotValidationPageState extends State<SpotValidationPage> {
  PageController controller = PageController();
  int currentIndex = 0;
  bool isLoading = false;
  Color backColor = kPrimary3;
  int crowdReportAvg = -1;
  int intensity = 1;
  String awaitingTime = "";

  @override
  void initState() {
    super.initState();
  }
  bool isAfter22(){
    return DateTime.now().hour > 21 || DateTime.now().hour < 7;
  }
  @override
  Widget build(BuildContext context) {
    var spots = widget.spots;
    if(spots.isNotEmpty && backColor==kPrimary3){
      backColor = spots[currentIndex].isClosedAt(DateTime.now()) || isAfter22()?kBackground:spots[currentIndex].getGemsNow() != 0
          ? kOffPeakTime
          : kFullTime;
      crowdReportAvg = spots[currentIndex].crowdReportAverageAt(DateTime.now());
      awaitingTime = spots[currentIndex].awaitingTimeAverage(DateTime.now());
    }
    return Scaffold(
      backgroundColor: backColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
        child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: kPadding40),
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle.light);

                    Navigator.pop(context);
                  },
                    icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                ),
              ),
              Flexible(
                child: PageView.builder(
                  controller: controller,
                  itemCount: spots.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      backColor = spots[currentIndex].isClosedAt(DateTime.now())?kBackground2:spots[index].getGemsNow() != 0
                          ? kOffPeakTime
                          : kFullTime;
                      crowdReportAvg = spots[currentIndex].crowdReportAverageAt(DateTime.now());
                      awaitingTime = spots[currentIndex].awaitingTimeAverage(DateTime.now());
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(kPadding20),
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
                                  crowdReport(spots[index],crowdReportAvg)
                                else
                                  const SizedBox(width: 105,height: 50,),

                                if (!spots[index].isClosedAt(DateTime.now()))
                                  gemCircle(spots[index]),

                                if (crowdReportAvg!=-1 && awaitingTime!='0\'')
                                  crowdWaitingTime(awaitingTime)
                                else
                                  const SizedBox(width: 105,height: 50,),

                              ],),
                          ),
                          buildIso(spots[index]),
                          const SizedBox(height: kPadding10),
                          SizedBox(
                            height: 35,
                            child: Text(
                              spots[index].name,
                              style: kBoldARPDisplay16.copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          const SizedBox(height: kPadding20),
                          spots[index].isClosedAt(DateTime.now())?Container(height: 100,): buildButtons(spots[index]),
                          const SizedBox(height: kPadding10),
                          if (!spots[index].isInCircleRadius(widget.userPosition))
                            SizedBox(
                              height:15,
                              child: Text(
                                "Vous êtes à ${spots[index].getDistance(widget.userPosition)} du spot",
                                style: kRegularNunito14,
                              ),
                            )
                          else
                            Container(height: 15,)
                        ],
                      ),
                    );
                  },),
              ),
              spots.length>1?Container(
                alignment: Alignment.bottomCenter,
                margin:  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(spots.length,(index){
                    return Container(
                      decoration: BoxDecoration(
                          color: index == currentIndex?kBlackGreen:const Color(0xffa4b5ae),
                          shape: BoxShape.circle
                      ),
                      margin: const EdgeInsets.only(left: kPadding5),
                      height: 8,
                      width: 8,
                    );
                  }),
                ),
              ):Container(height: 8,)
            ]),
      ),
    );
  }

  Widget buildButtons(spot) {
    return Container(
      height: 100,
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
        else if(getGems(spot) == 0 )
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
        else if(spot.isInCircleRadius(widget.userPosition))
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
                      builder: (context) => ValidationSuccessOrAlreadyPage(userPosition: widget.userPosition, spot: spot),
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
        if(spot.isInCircleRadius(widget.userPosition) && !isAfter22())
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
                        spot: spot,
                        userPosition: widget.userPosition,
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
          )
      ]),
    );
  }

  Widget gemCircle(Spot spot) {
    return Align(
      alignment: Alignment.topCenter,
      child: spot.getGemsNow() > 0 && !spot.isClosedAt(DateTime.now())?Container(
        height: 69,
        width: 69,
        decoration: BoxDecoration(
          color: spot.isSponsoredNow() && getGems(spot) > 0 ? null : kPrimary,
          borderRadius: BorderRadius.circular(kRadius100),
          gradient: spot.isSponsoredNow() && getGems(spot) > 0
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
                getGems(spot).toString(),
                style: kBoldARPDisplay20.copyWith(
                  color: spot.isSponsoredNow() && getGems(spot) > 0 ? kPrimary : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ):Container(),
    );
  }

  Widget crowdWaitingTime(spot) {
    return Container(
      alignment: Alignment.topRight,
      width: 105,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20,20,20,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: kPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: SvgPicture.asset(
                    width: 18,
                    "assets/svg/hour_glass.svg",
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
      ),
    );
  }

  Widget crowdReport(spot,crowdReportAvg) {
    return Container(
      alignment: Alignment.topLeft,
      width: 105,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20,20,20,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration:  BoxDecoration(
                color: spot.getGemsNow() != 0
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
                overflow: TextOverflow.ellipsis,
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

  Widget buildIso(spot) {
    return SizedBox(
      width: 250,
      height: 250,
      child: FutureBuilder<String>(
          future: FirebaseStorage.instance.ref().child("spot/iso/${spot.imageIsoPath}").getDownloadURL(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return CachedNetworkImage(
                imageUrl: snapshot.data!,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Container(),
                imageBuilder: (context, imageProvider) => Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        spot.isClosedAt(DateTime.now())? Container(
                          margin: const EdgeInsets.only(top:250/4 ),
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

                        if (!spot.isClosedAt(DateTime.now()))
                          Image.asset(
                            'assets/images/${getIntensity(spot)*2}people.png',
                            height: 250,
                            width: 250,
                          ),
                        buildDiscoverButton(spot),
                      ],
                    )),
              );
            }
            return const SizedBox(
              width: 250,
              height: 250,
            );
          }),
    );
  }

  Widget buildDiscoverButton(spot) {
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
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              try{
                AppConstants.explorePageKey.currentState!.zoomInSpot(spot.getLatLng());
              }catch(e){}
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: Text(
              "Voir sur la carte",
              textAlign: TextAlign.center,
              style: kBoldNunito16.copyWith(color: kPrimary),
            ),
          ),
        ),
      ],
    );
  }

  int getGems(spot) {
    if (DateTime.now().hour > 21 || DateTime.now().hour < 7) {
      return 0;
    }
    return spot.getGemsNow();
  }

  String getHourText(spot) {
    if (DateTime.now().hour < 7 || DateTime.now().hour > 21) {
      return "";
    }
    if (spot.getGemsNow() == 0) {
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
