import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class IntensitySlider extends StatefulWidget {
  final void Function(int) onChanged;
  const IntensitySlider({super.key, required this.onChanged});

  @override
  State<IntensitySlider> createState() => _IntensitySlider();
}

class _IntensitySlider extends State<IntensitySlider> {
  late int intensity = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Center(
              child: Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(kRadius100),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 0,
                  activeTrackColor: kSecondary,
                  inactiveTrackColor: kSecondary,
                  thumbShape: const SliderThumbCircle(
                    thumbRadius: 23,
                    min: 1,
                    max: 9,
                  )),
              child: Slider(
                min: 1,
                max: 9,
                divisions: 9,
                value: intensity.toDouble(),
                onChanged: (newDensity) {
                  setState(() {
                    intensity = newDensity.toInt();
                  });
                  widget.onChanged(intensity.toInt());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Source: https://medium.com/flutter-community/flutter-sliders-demystified-4b3ea65879c
class SliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const SliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    /// Thumb Background Color
    final paint = Paint()
      ..color = kPrimary
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: kBoldNunito20.copyWith(color: Colors.white),
      text: getValue(value),
    );

    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter = Offset(
        center.dx - (tp.width / 2),
        center.dy -
            (tp.height / 3)); // < Initialy 2. But due to the font weird padding, it became 3 to center the text.

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
