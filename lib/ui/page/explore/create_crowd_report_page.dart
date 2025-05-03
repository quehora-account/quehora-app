import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/create_crowd_report/create_crowd_report_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/widget/map/intensity_slider.dart';
import 'package:hoora/ui/widget/map/duration_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

import '../../../common/alert.dart';
import '../../../common/globals.dart';
import 'crowd_report_validation.dart';

class CreateCrowdReportPage extends StatefulWidget {
  final Spot spot;
  final LatLng userPosition;
  const CreateCrowdReportPage(
      {super.key, required this.spot, required this.userPosition});

  @override
  State<CreateCrowdReportPage> createState() => _CreateCrowdReportPageState();
}

class _CreateCrowdReportPageState extends State<CreateCrowdReportPage> {
  int hour = 0;
  int minute = 0;
  int intensity = 1;

  @override
  void initState() {
    super.initState();
    context.read<CreateCrowdReportBloc>().add(IsAlreadyReported(spotId: widget.spot.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary2,
      body: BlocConsumer<CreateCrowdReportBloc, CreateCrowdReportState>(
        listener: (context, state) {
          if (state is CreateCrowdReportSuccess) {
            context.read<UserBloc>().add(AddGem(gem: 5));
            try{
              AppConstants.explorePageKey.currentState!.updateView2();
            }catch(e){}
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CrowdReportValidation(),
              ),
            );
          }

          if (state is CreateCrowdReportFailed) {
            Alert.showError(context, state.exception.message);
          }
        },
        builder: (context, state) {
          if (state is ReportAlreadyCreatedLoading) {
            return const SafeArea(
                child: Padding(
              padding: EdgeInsets.all(kPadding20),
              child: Center(
                child: CircularProgressIndicator(
                  color: kPrimary,
                ),
              ),
            ));
          }

          if (state is ReportAlreadyCreated) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: kPadding40),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animations/chest.json",fit: BoxFit.cover,width: 270),
                      const SizedBox(height: kPadding20),
                      const SizedBox(
                        height: 90,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Vous avez déjà partagé l’affluence de ce site,  revenez dans  1 heure !",
                            style: kBoldARPDisplay18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: kPadding40),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

                      Navigator.pop(context);
                    },
                    icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                  ),
                ),
                const SizedBox(height: kPadding40,),
                Text(
                  "Quel est le niveau\nd'affluence actuel ?",
                  style: kBoldARPDisplay14.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kPadding20),
                LayoutBuilder(builder: (context, constraint) {
                  return SizedBox(
                    height: constraint.maxWidth * 0.6,
                    width: constraint.maxWidth * 0.6,
                    child: FutureBuilder<String>(
                        future: FirebaseStorage.instance
                            .ref()
                            .child("spot/iso/${widget.spot.imageIsoPath}")
                            .getDownloadURL(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) => Container(),
                              imageBuilder: (context, imageProvider) => LayoutBuilder(builder: (_, constraint) {
                                return Container(
                                  width: constraint.maxWidth,
                                  constraints: BoxConstraints(
                                    maxWidth: constraint.maxWidth,
                                    maxHeight: constraint.maxWidth,
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (intensity >= 1)
                                        Center(child: Image.asset("assets/images/${intensity*2}people.png")),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kPrimary,
                                            borderRadius: BorderRadius.circular(kPadding20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: kPadding5,horizontal: kPadding10),
                                            child: Text(
                                              crowdReportSentences[intensity - 1],
                                              style: kBoldNunito16.copyWith(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }),
                            );
                          }
                          return LayoutBuilder(builder: (_, constraint) {
                            return Container(
                              constraints: BoxConstraints(
                                maxWidth: constraint.maxWidth,
                                maxHeight: constraint.maxWidth,
                              ),
                            );
                          });
                        }),
                  );
                }),
                const SizedBox(height: kPadding20),
                IntensitySlider(onChanged: (newIntensity) {
                  setState(() {
                    intensity = newIntensity;
                  });
                }),
                const Spacer(),
                Text(
                  "Avez-vous attendu\npour accéder au site ?",
                  style: kBoldARPDisplay14.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kPadding40),
                DurationButton(
                  onDurationChanged: (hour, minute) {
                    this.hour = hour;
                    this.minute = minute;
                  },
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: kButtonRoundedStyle,
                    onPressed: state is CreateCrowdReportLoading
                        ? null
                        : () {
                      context.read<CreateCrowdReportBloc>().add(
                        CreateCrowdReport(
                            duration: "$hour:$minute",
                            spotId: widget.spot.id,
                            intensity: intensity,
                            coordinates: [
                              43.6,
                              43.6
                            ]
                        ),
                      );
                    },
                    child: state is CreateCrowdReportLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Je partage mon ressenti",
                          style: kBoldNunito16.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: kPadding10),
                        SvgPicture.asset("assets/svg/gem.svg"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
