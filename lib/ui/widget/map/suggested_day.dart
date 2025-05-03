import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

class SuggestedDay extends StatefulWidget {
  final String title;
  final int weekday;
  final Spot spot;
  bool isSelected = false;
  SuggestedDay({
    super.key,
    required this.title,
    required this.weekday,
    required this.isSelected,
    required this.spot,
  });

  @override
  State<SuggestedDay> createState() => _SuggestedDayState();
}

class _SuggestedDayState extends State<SuggestedDay> {
  late Map<String, int> popularTime;

  @override
  void initState() {
    super.initState();
    popularTime = widget.spot.popularTimes[widget.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    late String path;
    var backColor = Colors.white;
    if (widget.spot.hasOpenHoursAt(widget.weekday)) {
      path = 'assets/svg/black_lock.svg';
    } else {
      double ptAverage = getPopularTimeAverage();
      double ptsAverage = getPopularTimesAverage();
      path = getSmileyPath(ptAverage - ptsAverage);
      backColor = ptAverage - ptsAverage>0?kFullTime:kOffPeakTime;
    }
    return SizedBox(
      width: 38+5,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 38,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  SizedBox(height: 20, width: 20, child: SvgPicture.asset(path)),
                  const SizedBox(height: kPadding5),
                  Text(
                    widget.title.substring(0,3).toUpperCase(),
                    style: kBoldNunito10.copyWith(fontWeight: !widget.isSelected?FontWeight.w600:FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
                width: 38+2.25,
                height: 45+2.25,
                decoration: BoxDecoration(
                  border: widget.isSelected?Border.all(color: kPrimary,width: 3):null,
                  borderRadius: BorderRadius.circular(kPadding10),
                )),
          ),
        ],
      ),
    );
  }

  String getSmileyPath(double num) {
    String index = "2";
    if (num > 12) {
      index = "10";
    } else if (num < 12 && num >= 6) {
      index = "7";
    } else if (num < 6 && num >= 0) {
      index = "5";
    } else if (num < 0 && num >= -6) {
      index = "4";
    } else if (num < -6 && num >= -12) {
      index = "3";
    } else if (num < -12) {
      index = "2";
    }
    return "assets/svg/smiley_$index.svg";
  }

  /// From actual PT
  double getPopularTimeAverage() {
    int length = 0;
    int total = 0;

    for (String key in popularTime.keys) {
      if (popularTime[key]! > 0) {
        length++;
        total += popularTime[key]!;
      }
    }
    return total / length;
  }

  /// From PT of the week (monday to sunday).
  double getPopularTimesAverage() {
    int length = 0;
    int total = 0;

    for (Map<String, int> pt in widget.spot.popularTimes) {
      for (String key in pt.keys) {
        if (pt[key]! > 0) {
          length++;
          total += pt[key]!;
        }
      }
    }
    return total / length;
  }
}
