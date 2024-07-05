import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class HourSlider extends StatefulWidget {
  final void Function(int)? onChangedEnd;
  final void Function(int)? onChanged;
  final int initialHour;
  const HourSlider({super.key, this.onChangedEnd, this.onChanged, required this.initialHour});

  @override
  State<HourSlider> createState() => _HourSliderState();
}

class _HourSliderState extends State<HourSlider> {
  late int hour;

  @override
  void initState() {
    super.initState();
    hour = widget.initialHour;
  }

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
                    min: 7,
                    max: 21,
                  )),
              child: Slider(
                min: 7,
                max: 21,
                divisions: 14,
                value: hour.toDouble(),
                onChanged: (newHour) {
                  setState(() {
                    /// Make the slider more smooth
                    // newHour = newHour + 0.5;
                    hour = newHour.toInt();
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(hour.toInt());
                  }
                },
                onChangeEnd: (hour) {
                  if (widget.onChangedEnd != null) {
                    widget.onChangedEnd!(hour.toInt());
                  }
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
      text: "${getValue(value)}h",
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
