import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class Navigation extends StatefulWidget {
  final void Function(int index) onChanged;
  const Navigation({super.key, required this.onChanged});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  void onPressed(int index) {
    if (index != currentIndex) {
      if(index !=2){
        currentIndex = index;
      }
      widget.onChanged(index);
    }
  }

  Widget _buildButton(String svgPath, String svgSelectedPath, int index,String label) {
    return InkWell(
      borderRadius: BorderRadius.circular(kRadius100),
      onTap: () => onPressed(index),
      child: SizedBox(
        height: 50,
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              "assets/svg/$svgPath",
              color: index != currentIndex ? kBlackGreen:kLightGreen ,
              height: 26,
            ),
            Text(label,style: index != currentIndex ? kBoldNunito10:kRegularNunito10,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildButton("explore.svg", "explore_blue.svg", 0,"Explore"),
          _buildButton("gift.svg", "gift_blue.svg", 1,"Cadeaux"),
          _buildMainButton(),
          _buildButton("challenge.svg", "challenge_blue.svg", 3,"Challenge"),
          _buildButton("ranking.svg", "ranking_blue.svg", 4,"Classement"),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius100),
            color: kBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(kRadius100),
            color: kBackground,
            child: InkWell(
              borderRadius: BorderRadius.circular(kRadius100),
              onTap: () => onPressed(2),
              child: Center(
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRadius100),
                    color: kPrimary,
                  ),
                  child: Lottie.asset("assets/animations/gem.json"),
                ),
              ),
            ),
          ),
        ),
        const Text("Validation",style: kBoldNunito10,),
      ],
    );
  }
}
