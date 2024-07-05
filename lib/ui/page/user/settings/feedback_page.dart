import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: Column(
            children: [
              /// back button
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
              const Center(
                  child: Text(
                "Feedback",
                style: kBoldARPDisplay14,
              )),
              const Spacer(),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: SvgPicture.asset("assets/svg/storm_circle.svg"),
              ),
              const SizedBox(height: kPadding40),
              const Text(
                "Vous voulez nous signalez un\nbug, une anomalie ou juste nous\nfaire une suggestion, contactez\nsupport@quehora.app ou bien\nrendez vous sur notre page\nInstagram quehora.app.",
                style: kRegularNunito16,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
