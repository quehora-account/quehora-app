import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/widget/rounded_page_indicator.dart';

class Tips extends StatefulWidget {
  final Spot spot;
  const Tips({super.key, required this.spot});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> tips = widget.spot.tips;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kRadius20),
      ),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: Text(
                  tips[index],
                  style: kRegularNunito20.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ));
            },
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kPadding20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RoundedPageIndicator(
                length: tips.length,
                currentIndex: currentIndex,
                selectedColor: Colors.white,
                unselectedColor: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
