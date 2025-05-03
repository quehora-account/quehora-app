import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/model/spot_model.dart';

class MinimalSpot extends StatefulWidget {
  final DateTime weekday;
  final Spot spot;
  const MinimalSpot({
    super.key,
    required this.weekday,
    required this.spot,
  });

  @override
  State<MinimalSpot> createState() => _SuggestedDayState();
}

class _SuggestedDayState extends State<MinimalSpot> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> bestTimes2 = bestTimes(widget.weekday);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(bestTimes2.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: kPadding10),
              height: 60,
              width: 80,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                          color: kOffPeakTime,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              spreadRadius: 0,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.white,width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(30))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 2,),
                          Text(bestTimes2[index]['gems'].toString(), style: kBoldARPDisplay13, textAlign: TextAlign.center),
                          Text("${widget.weekday.getWeekday().substring(0,3)}. ${bestTimes2[index]['hour']}h", style: kRegularNunito14, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  Align(alignment:Alignment.topCenter,child: SvgPicture.asset("assets/svg/gem.svg",width: 26,)),
                ],
              ),
            );

          },),
        ),
        bestTimes2.isNotEmpty?
        Column(children: [
          const SizedBox(height: kPadding20),
          Text("Moments à privilégier ${widget.weekday.getWeekday()}", style: kBoldNunito14, textAlign: TextAlign.center),
        ],)  :Container()
      ],
    );
  }

  List<dynamic> bestTimes (DateTime date){
    var list  = [];
    for (int i = 7; i <= 21; i++) {
      int hour = int.parse(widget.spot.visitDuration.split(":")[0]);
      int minute = int.parse(widget.spot.visitDuration.split(":")[1]);

      if(!widget.spot.isClosedAt(date.copyWith(hour: i)) && !widget.spot.isClosedAt(date.copyWith(hour: i+hour,minute: minute))){
        list.add({
          'hour': i,
          'gems': widget.spot.getGemsAt(date.copyWith(hour: i)),
          'pt' :widget.spot.getPopularTimeAt(date.copyWith(hour: i))
        });
      }
    }
    list.sort((a, b) {
      int gemsComparison = b['gems'].compareTo(a['gems']);
      if (gemsComparison != 0) {
        return gemsComparison; // Sort by 'gems' if not equal
      } else {
        return a['pt'].compareTo(b['pt']); // Sort by 'pt' if 'gems' are equal
      }
    });
    if(list.length>=3) {
      return list.getRange(0,3).toList();
    }else{
      return list;
    }
  }
}
