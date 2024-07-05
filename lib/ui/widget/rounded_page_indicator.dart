import 'package:flutter/material.dart';

class RoundedPageIndicator extends StatelessWidget {
  final int length;
  final int currentIndex;
  final Color selectedColor;
  final Color unselectedColor;
  const RoundedPageIndicator({
    super.key,
    required this.length,
    required this.currentIndex,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentIndex == i ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
