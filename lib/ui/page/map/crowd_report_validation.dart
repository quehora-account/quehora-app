import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:lottie/lottie.dart';

class CrowdReportValidation extends StatefulWidget {
  const CrowdReportValidation({super.key});

  @override
  State<CrowdReportValidation> createState() => _CrowdReportValidationState();
}

class _CrowdReportValidationState extends State<CrowdReportValidation> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary3,
      body: BlocConsumer<ExploreBloc, ExploreState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              Lottie.asset("assets/animations/confetis.json", fit: BoxFit.cover),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(kPadding20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.arrow_left,
                            size: 32,
                            color: kPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Text(
                          "Bravo !\nVotre action compte !",
                          style: kBoldARPDisplay18,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Container(
                        height: 160,
                        width: 200,
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.only(bottom: kPadding40),
                              child: Lottie.asset("assets/animations/gem.json", width: 100),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "5",
                                  style: kBoldARPDisplay32.copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
