import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';

class GemProgressBar extends StatelessWidget {
  final int value;
  final int goal;
  const GemProgressBar({super.key, required this.value, required this.goal});

  @override
  Widget build(BuildContext context) {
    double pourcentage = 100 * (value / goal);

    return Container(
      height: 25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadius100),
                  ),
                  child: Center(
                    child: LayoutBuilder(builder: (_, constraint) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: constraint.maxHeight,
                            width: constraint.maxWidth * (pourcentage / 100),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(26, 213, 124, 1),
                              borderRadius: BorderRadius.circular(kRadius100),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(width: kPadding10),
            Text(
              "${value.toString()}/${goal.toString()}",
              style: kBoldARPDisplay11.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(width: kPadding10),
            SvgPicture.asset('assets/svg/gem.svg'),
          ],
        ),
      ),
    );
  }
}
