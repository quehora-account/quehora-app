import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/bloc/create_crowd_report/create_crowd_report_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/sentences.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/map/crowd_report_validation.dart';
import 'package:hoora/ui/widget/map/intensity_slider.dart';
import 'package:hoora/ui/widget/map/duration_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class CreateCrowdReportPage extends StatefulWidget {
  final Spot spot;
  const CreateCrowdReportPage({super.key, required this.spot});

  @override
  State<CreateCrowdReportPage> createState() => _CreateCrowdReportPageState();
}

class _CreateCrowdReportPageState extends State<CreateCrowdReportPage> {
  int hour = 0;
  int minute = 0;
  int intensity = 1;
  LatLng? userPosition;

  @override
  void initState() {
    super.initState();

    /// Update user position
    Geolocator.getPositionStream().listen((Position? position) {
      if (position != null) {
        setState(() {
          userPosition = LatLng(position.latitude, position.longitude);
        });
      }
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    context.read<CreateCrowdReportBloc>().add(IsAlreadyReported(spotId: widget.spot.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary3,
      body: BlocConsumer<CreateCrowdReportBloc, CreateCrowdReportState>(
        listener: (context, state) {
          if (state is CreateCrowdReportSuccess) {
            context.read<UserBloc>().add(AddGem(gem: 5));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CrowdReportValidation(),
              ),
            );
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
                        "Vous avez déjà partagé l'affluence de ce site, revenez demain !",
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

          return SafeArea(
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
                const Text(
                  "Quel est le niveau\nd'affluence actuel ?",
                  style: kBoldARPDisplay14,
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
                                      if (intensity > 1)
                                        Center(child: Image.asset("assets/images/intensity_$intensity.png")),
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
                Container(
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding10),
                    child: Text(
                      crowdReportSentences[intensity - 1],
                      style: kBoldNunito14.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: kPadding20),
                IntensitySlider(onChanged: (newIntensity) {
                  setState(() {
                    intensity = newIntensity;
                  });
                }),
                const Spacer(),
                const Text(
                  "Avez-vous attendu\npour accéder au site ?",
                  style: kBoldARPDisplay14,
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
          ));
        },
      ),
    );
  }
}
