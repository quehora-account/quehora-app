import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.25),
                  SizedBox(
                    height: constraints.maxHeight * 0.25,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Lottie.asset(
                          "assets/animations/golden_gem.json",
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Bienvenue !",
                    style: kBoldARPDisplay25,
                  ),
                  const SizedBox(height: kPadding5),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      "Prêt à embarquer pour votre première visite récompensée ?",
                      style: kRegularNunito20,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/first_launch/request_geolocation");
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        size: 32,
                        color: kPrimary,
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
