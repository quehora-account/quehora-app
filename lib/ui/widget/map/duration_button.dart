import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';

class DurationButton extends StatefulWidget {
  final void Function(int hour, int minute) onDurationChanged;
  const DurationButton({super.key, required this.onDurationChanged});

  @override
  State<DurationButton> createState() => _DurationButtonState();
}

class _DurationButtonState extends State<DurationButton> {
  int hour = 0;
  int minute = 0;

  String durationtoString() {
    if (hour < 1) {
      return '$minute\'';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: ElevatedButton(
            onPressed: () {
              if (hour == 0 && minute == 0) {
                return;
              }
              if (minute == 00) {
                hour -= 1;
                minute = 45;
              } else {
                minute -= 15;
              }
              setState(() {});
              widget.onDurationChanged(hour, minute);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: kUnselected,
              side: const BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: const Text(
              "-",
              style: kRegularNunito32,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: kPrimary,
              side: const BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: Text(
              durationtoString(),
              style: kBoldNunito16.copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: ElevatedButton(
            onPressed: () {
              if (hour == 10) {
                return;
              }

              minute += 15;
              if (minute == 60) {
                hour += 1;
                minute = 0;
              }
              setState(() {});
              widget.onDurationChanged(hour, minute);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: kUnselected,
              side: const BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: const Text(
              "+",
              style: kRegularNunito32,
            ),
          ),
        ),
      ],
    );
  }
}
