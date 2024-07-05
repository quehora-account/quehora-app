import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/common/decoration.dart';

class DatePage extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onSelected;
  const DatePage({super.key, required this.selectedDate, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: LayoutBuilder(builder: (_, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    size: 32,
                    color: kPrimary,
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.05),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Text(
                  "Quand prévoyez vous votre visite ?",
                  style: kBoldARPDisplay16,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Builder(builder: (_) {
                  List<Widget> children = [];
                  DateTime today = DateTime.now();

                  for (int i = 0; i < 7; i++) {
                    String displayedName;
                    DateTime displayedDate = today.add(Duration(days: i));

                    if (i == 0) {
                      displayedName = "Aujourd'hui";
                    } else if (i == 1) {
                      displayedName = "Demain";
                    } else {
                      displayedName = displayedDate.getWeekday();
                    }

                    children.add(Padding(
                      padding: const EdgeInsets.all(kPadding10),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: displayedDate.day == selectedDate.day ? kSecondary : kUnselected,
                          ),
                          onPressed: () {
                            if (displayedDate.day != selectedDate.day) {
                              Navigator.pop(context);
                              onSelected(displayedDate);
                            }
                          },
                          child: Text(
                            displayedName,
                            style: kBoldNunito16,
                          ),
                        ),
                      ),
                    ));
                  }
                  return Column(children: children);
                }),
              ),
              const Spacer(),
            ],
          );
        }),
      )),
    );
  }
}
