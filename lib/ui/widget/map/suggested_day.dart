import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';

class SuggestedDay extends StatefulWidget {
  final String title;
  final int weekday;
  final Spot spot;
  const SuggestedDay({
    super.key,
    required this.title,
    required this.weekday,
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
    if (widget.spot.hasOpenHoursAt(widget.weekday)) {
      path = 'assets/svg/lock.svg';
    } else {
      double ptAverage = getPopularTimeAverage();
      double ptsAverage = getPopularTimesAverage();
      path = getSmileyPath(ptAverage - ptsAverage);
    }
    return Column(
      children: [
        SizedBox(height: 25, width: 25, child: SvgPicture.asset(path)),
        const SizedBox(height: kPadding5),
        Text(
          widget.title,
          style: kBoldNunito10,
        ),
      ],
    );
  }

  String getSmileyPath(double num) {
    String index = "1";
    if (num > 12) {
      index = "7";
    } else if (num < 12 && num >= 8) {
      index = "6";
    } else if (num < 8 && num >= 4) {
      index = "5";
    } else if (num < 4 && num >= -4) {
      index = "4";
    } else if (num < -4 && num >= -8) {
      index = "3";
    } else if (num < -8 && num >= -12) {
      index = "2";
    } else {
      index = "1";
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
