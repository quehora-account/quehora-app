import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/bloc/validate_spot/validate_spot_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/explore/create_crowd_report_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';


class ValidationSuccessOrAlreadyPage extends StatefulWidget {
  final Spot spot;
  final LatLng userPosition;

  const ValidationSuccessOrAlreadyPage({super.key,required this.userPosition, required this.spot});

  @override
  State<ValidationSuccessOrAlreadyPage> createState() => _ValidationSuccessOrAlreadyPageState();
}

class _ValidationSuccessOrAlreadyPageState extends State<ValidationSuccessOrAlreadyPage> {

  @override
  void initState() {
    super.initState();
    context.read<ValidateSpotBloc>().add(ValidateSpot(spot: widget.spot, coordinates: [widget.userPosition.latitude,widget.userPosition.longitude]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ValidateSpotBloc, ValidateSpotState>(
        listener: (context, state) {
          if (state is ValidateSpotSuccess) {
            context.read<UserBloc>().add(AddGem(gem: state.gems));
          }
        },
        builder: (context, state) {
      
          if (state is ValidateSpotLoading) {
            return const Scaffold(
              backgroundColor: kPrimary2,
              body: Center(
                child: CircularProgressIndicator(color: kPrimary),
              ),
            );
          }

          return Scaffold(
            backgroundColor: kPrimary2,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
              child: Stack(
                children: [
                  state is ValidateSpotSuccess?
                  Stack(
                    children: [
                      Lottie.asset("assets/animations/confetis.json", fit: BoxFit.cover),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FractionallySizedBox(
                              widthFactor: 0.65,
                              child: Text(
                                "Bravo pour votre visite responsable !",
                                style: kBoldARPDisplay18,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(kPadding20),
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
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(kPadding10),
                          padding: EdgeInsets.all(kPadding10),
                          height: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                            ),
                            onPressed: () async {
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateCrowdReportPage(
                                    spot: widget.spot,
                                    userPosition: widget.userPosition,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                  "Je partage l'affluence",
                                  style: kBoldNunito16.copyWith(color: Colors.white),
                                ),
                                const SizedBox(width: kPadding10),
                                SvgPicture.asset("assets/svg/gem.svg"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ): state is SpotAlreadyValidated ?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animations/chest.json",fit: BoxFit.cover,width: 270),
                      const SizedBox(height: kPadding20),
                      const SizedBox(
                        height: 90,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Vous avez déjà visité ce site, revenez demain !",
                            style: kBoldARPDisplay18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ):Container(),

                  Container(
                    margin:  const EdgeInsets.only(top: kPadding40),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                        Navigator.pop(context);
                      },
                      icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
