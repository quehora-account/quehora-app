import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/bloc/validate_spot/validate_spot_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/map/create_crowd_report_page.dart';
import 'package:lottie/lottie.dart';

class SpotValidationPage extends StatefulWidget {
  final Spot spot;
  const SpotValidationPage({super.key, required this.spot});

  @override
  State<SpotValidationPage> createState() => _SpotValidationPageState();
}

class _SpotValidationPageState extends State<SpotValidationPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    context.read<ValidateSpotBloc>().add(ValidateSpot(spot: widget.spot));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary3,
      body: BlocConsumer<ValidateSpotBloc, ValidateSpotState>(
        listener: (context, state) {
          if (state is ValidateSpotSuccess) {
            context.read<UserBloc>().add(AddGem(gem: state.gems));
          }
        },
        builder: (context, state) {
          if (state is ValidateSpotLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimary),
            );
          }

          if (state is SpotAlreadyValidated) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: Center(
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
                      Lottie.asset("assets/animations/chest.json",
                          fit: BoxFit.cover),
                      const SizedBox(height: kPadding20),
                      const Text(
                        "Vous avez déjà visité ce site, revenez demain !",
                        style: kBoldARPDisplay18,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

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
                          "Bravo pour votre visite responsable !",
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
                                  widget.spot.getGemsNow().toString(),
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
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCrowdReportPage(
                                  spot: widget.spot,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Je partage l'affluence",
                                style: kBoldNunito16,
                              ),
                              const SizedBox(width: kPadding10),
                              SvgPicture.asset("assets/svg/gem.svg"),
                            ],
                          ),
                        ),
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
