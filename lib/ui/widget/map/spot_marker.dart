
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

class SpotMarker extends StatelessWidget {
  final Spot spot;
  final String imageCode;
  final DateTime selectedDate;
  final Function() clicked;
  const SpotMarker({super.key,required this.clicked, required this.spot, required this.imageCode,required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    int crowdReportAvg = spot.crowdReportAverageAt(selectedDate);
    final awaitingTime = spot.awaitingTimeAverage(selectedDate);
    return Stack(
      children: [
        /// Main circle
        Center(
          child: InkWell(
            onTap: (){
              clicked();
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: spot.isSponsoredNow() && spot.getGemsAt(selectedDate) > 0 ? null :(spot.isClosedAt(selectedDate))?Colors.white: spot.getGemsAt(selectedDate) > 0?kOffPeakTime:kFullTime,
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(kRadius100),
                gradient: spot.isSponsoredNow() && spot.getGemsAt(selectedDate) > 0
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
              child: Center( child: SvgPicture.string(imageCode)
              ),
            ),
          ),
        ),
        /// Gem
        if(spot.getGemsAt(selectedDate)>0 && !spot.isClosedAt(selectedDate))
           Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: kPadding5),
            width: 44,
            height: 18,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(kRadius100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    spot.getGemsAt(selectedDate).toString(),
                    style: kBoldARPDisplay13.copyWith(color:Colors.white),
                  ),
                  const SizedBox(width: 1,),
                  SvgPicture.asset(
                    "assets/svg/gem.svg",
                    height: 12,
                    width: 12,
                  ),
                ],
            ),
          ),
        ),

        if (crowdReportAvg!=-1 && awaitingTime!='0\'' && !spot.isClosedAt(selectedDate) )
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(kRadius100),
              ),
              child: Center(
                  child: SvgPicture.asset(
                "assets/svg/hour_glass.svg",
                height: 20,
              )),
            ),
          ),
         (spot.isClosedAt(selectedDate))?
          Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 33,
            width: 33,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(kRadius100),
            ),
              child: const Center(
                child: Icon(Icons.lock,size: 20,color: Colors.white,),
              ),
          ),
        )
        :(crowdReportAvg!=-1)?
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: crowdReportAvg>5?kFullTimeDarker:kOffPeakTimeDarker,
                borderRadius: BorderRadius.circular(kRadius100),
              ),
              child: Center(
                  child: SvgPicture.asset(
                "assets/svg/smiley_$crowdReportAvg.svg",
                height: 20,
              )),
            ),
          ):Container(),
      ],
    );
  }

  int getGems() {
    DateTime date = DateTime.now();
    if (date.hour > 21 || date.hour < 7) {
      return 0;
    }
    return spot.getGemsNow();
  }
}
