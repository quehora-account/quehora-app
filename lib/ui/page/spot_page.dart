import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/bloc/spotPage/spot_page_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/hour_extension.dart';
import 'package:hoora/model/hours_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/model/tarification_model.dart';
import 'package:hoora/tools.dart';
import 'package:hoora/ui/widget/explore/hour_slider.dart';
import 'package:hoora/ui/widget/map/gallery.dart';
import 'package:hoora/ui/widget/map/minimal_spot.dart';
import 'package:hoora/ui/widget/map/suggested_day.dart';
import 'package:hoora/ui/widget/map/tarification.dart';
import 'package:hoora/ui/widget/map/tips.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/alert.dart';
import '../../model/offer_model.dart';
import '../widget/offer/offer_card.dart';
import 'explore/spot_validation_page.dart';
class SpotPage extends StatefulWidget {
  final Spot spot;
  LatLng? userPosition;
  SpotPage({super.key,this.userPosition, required this.spot});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  PageController controller = PageController();
  int currentIndex = 0;
  late int intensity;
  late int hour;
  bool firstTime = true;
  StreamSubscription<Position>? positionStream;
  LatLng? userPosition;
  List<Offer> offers = [];
  @override
  void initState() {
    super.initState();
    hour = selectedDate.getFormattedHour();
    selectedDate = today;
    intensity = getIntensity();
    offers = [];
    context.read<SpotPageBloc>().add(Init(cityId: widget.spot.cityId,spotPosition: widget.spot.getLatLng()));
    positionStream = Geolocator.getPositionStream().listen((Position? position) {
      if (position != null && mounted) {
        if(userPosition!=null && firstTime){
          firstTime = false;
        }
        final newPosition = LatLng(position.latitude, position.longitude);
        userPosition = newPosition;
      }
    });
    if(widget.userPosition==null){
      Tools.enableLocation();
    }else{
      userPosition = widget.userPosition;
    }

  }

  @override
  Widget build(BuildContext context) {
    Spot spot = widget.spot;
     final GlobalKey<HourSliderState> hourKey = GlobalKey<HourSliderState>();
    return Scaffold(
      backgroundColor: kBackground2,
      body: BlocConsumer<SpotPageBloc, SpotPageState>(
        listener: (context, state) {
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }
        },
        builder: (context, state) {

          if (state is InitSuccess) {
            debugPrint("SALAM");
            offers = state.offers;
          }
          return Scaffold(
            backgroundColor: kBackground2,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kPadding40,
                      ),
                      /// Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: kPrimary,height: 22,width: 22,),
                        ),
                      ),

                      /// Pictures
                      const SizedBox(height: kPadding20),
                      if (widget.spot.imageGalleryPaths.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: kPadding20),
                          child: Gallery(spot: spot),
                        ),
                      Text(spot.type, style: kRegularNunito16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding10),
                      Text(spot.name, style: kBoldARPDisplay16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding10),
                      Text(spot.cityName, style: kRegularNunito16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xffE1E1E1),
                              borderRadius: BorderRadius.circular(kRadius100),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/svg/clock.svg",color:Colors.black),
                                    const SizedBox(width: kPadding5),
                                    Text(
                                      getVisitDuration(),
                                      style: kBoldNunito16.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: kPadding10),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xffE1E1E1),
                              borderRadius: BorderRadius.circular(kRadius100),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.star_fill,
                                      color: Color(0xffFFCC40),
                                      size: 20,
                                    ),
                                    const SizedBox(width: kPadding5),
                                    Text(
                                      spot.rating.toString(),
                                      style: kBoldNunito16.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kPadding20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: kPadding40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              padding: const EdgeInsets.all(15.0)
                          ),
                          onPressed: (){
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => SpotValidationPage(
                            //       userPosition: const LatLng(-1, -1), spots: [spot],fromLoadingPage: true,
                            //     ),
                            //   ),
                            // );
                            if(userPosition!=null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpotValidationPage(
                                    userPosition: userPosition!, spots: [spot],fromLoadingPage: true,
                                  ),
                                ),
                              );
                            }else{
                              Tools.enableLocation();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Je suis sur place",
                                style: kBoldNunito16.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: kPadding20),
                      Text(spot.description, style: kRegularNunito16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(kRadius15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(children: [
                          const SizedBox(height: kPadding40),
                          const Text("Quand visiter ?", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                          const SizedBox(height: kPadding40),
                          buildSuggestedDay(),
                          const SizedBox(height: kPadding20),

                          /// ISO
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
                                                  if (spot.isClosedAt(selectedDate.copyWith(hour: hour)))
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: 45,
                                                            width: 45,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.white,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Center( child:SvgPicture.asset("assets/svg/black_lock.svg",width: 18,height: 24,),
                                                            ),
                                                          ),
                                                          const SizedBox(height: kPadding10,),
                                                          Container(
                                                            padding: const EdgeInsets.all(kPadding10),
                                                            decoration: const BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.all( Radius.circular(kRadius20))),
                                                            child: const Text("Fermé",style: kBoldNunito16,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (!spot.isClosedAt(selectedDate.copyWith(hour: hour)) && intensity >= 1)
                                                    Image.asset(
                                                      'assets/images/${intensity*2}people.png',
                                                      height: constraint.maxWidth,
                                                      width: constraint.maxWidth,
                                                    ),
                                                ],
                                              ));
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      if(hour>7){
                                        hourKey.currentState!.changeHourFromChevrons(hour-1);
                                        setState(() {
                                          hour = hour-1;
                                          intensity = getIntensity();
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(kPadding10),
                                      child: const Icon(CupertinoIcons.left_chevron,color: Color(0xff0e1626),size: 20,)),
                                ),
                                Flexible(
                                  child: HourSlider(
                                    height: 17,
                                    key: hourKey,
                                    thumbColor: const Color(0xffeeeeee),
                                    initialHour: hour,
                                    onChangedEnd: (hour) {
                                      setState(() {
                                        this.hour = hour;
                                        intensity = getIntensity();
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      if(hour<21){
                                        hourKey.currentState!.changeHourFromChevrons(hour+1);
                                        setState(() {
                                          hour = hour+1;
                                          intensity = getIntensity();
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(kPadding10),child: const Icon(CupertinoIcons.right_chevron,color: Color(0xff0e1626),size: 20,)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: kPadding20),
                          MinimalSpot(weekday: selectedDate, spot: spot),
                          const SizedBox(height: kPadding20),
                        ],),
                      ),
                      const SizedBox(height: kPadding40),
                      const Text("Tarifs",
                          style: kBoldARPDisplay16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding20),
                      buildTarifications(),
                      const SizedBox(height: kPadding40),
                      const Text("Astuce de voyageurs",
                          style: kBoldARPDisplay16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding20),
                      Tips(spot: widget.spot),
                      const SizedBox(height: kPadding40),
                      const Text("Heures d'ouverture", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding20),
                      buildOpenHours(),
                      const SizedBox(height: kPadding40),
                      if(state is InitLoading)
                          Container()
                      else if(offers.isNotEmpty)
                          offersWidget(offers),
                      const Text("A ne pas manquer !", style: kBoldARPDisplay16, textAlign: TextAlign.center),
                      const SizedBox(height: kPadding20),
                      buildHighlights(),
                      const SizedBox(height: kPadding40),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: 39,
                          width: 130,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () async {
                                Uri url = Uri.parse(widget.spot.website);

                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SvgPicture.asset("assets/svg/website.svg"),
                                  const SizedBox(width: kPadding10),
                                  const Text(
                                    "Site Web",
                                    style: kBoldNunito16,
                                  ),
                                  const Spacer(),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(height: kPadding20),
                      SizedBox(
                        height: 39,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: kButtonRoundedStyle,
                            onPressed: () async {
                              Uri url = Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=France, ${widget.spot.cityName}, ${widget.spot.name}');

                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            child: Text(
                              "Ouvrir Google Maps",
                              style: kBoldNunito16.copyWith(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget offersWidget(List<Offer> offers){
    return Column(
      children: [
        const Text("Dépensez vos\nDiamz à  proximité", style: kBoldARPDisplay16, textAlign: TextAlign.center),
        const SizedBox(height: kPadding20),
        SizedBox(
          /// 10 for the shadow to be displayed
          height:offers.isNotEmpty?  170 + 10:0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            itemBuilder: (_, index) {
              Offer offer = offers[index];
              EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

              if (index == 0) {
                padding = const EdgeInsets.only(left: 20, right: 10);
              }

              if (index == offers.length - 1 && offers.length > 1) {
                padding = const EdgeInsets.only(right: 20);
              }

              return Padding(
                padding: padding,
                child: Align(alignment: Alignment.topCenter, child: OfferCard(offer: offer,isFromSpotPage: true,)),
              );
            },
          ),
        ),
        const SizedBox(height: kPadding40),
      ],
    );
  }

  int getIntensity() {
    /// Get density
     int averageTrafficPoint = widget.spot.calcTrafficPointUsingCrowdReport(selectedDate.copyWith(hour: hour));
     int trafficPoint = widget.spot.getTrafficPointAt(selectedDate.copyWith(hour: hour));
    ///there is a report
    if(averageTrafficPoint!=-1){
      if(averageTrafficPoint>=0 && averageTrafficPoint<10){
        averageTrafficPoint = 10;
      }
      if(averageTrafficPoint>-10 && averageTrafficPoint<0){
        averageTrafficPoint = -10;
      }
      trafficPoint = averageTrafficPoint;
    }
    switch(trafficPoint){
      case 30:
        return 1;
      case 25:
        return 2;
      case 20:
        return 3;
      case 15:
        return 4;
      case 10:
        return 5;
      case -10:
        return 6;
      case -15:
        return 7;
      case -20:
        return 8;
      case -25:
        return 9;
      case -30:
        return 10;
    }
    return 1;
  }

  String getVisitDuration() {
    int hour = int.parse(widget.spot.visitDuration.split(":")[0]);
    int minute = int.parse(widget.spot.visitDuration.split(":")[1]);

    if (hour < 1) {
      return '$minute min';
    }

    if (minute < 15) {
      return '${hour}h';
    }

    return '${hour}h$minute';
  }

  Widget buildTarifications() {
    List<Widget> children = [];
    TarificationModel? fullP = widget.spot.fullPrice;
    TarificationModel? reducedP = widget.spot.reducedPrice;
    TarificationModel? freeP = widget.spot.freePrice;

    if (fullP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/full.svg", data: fullP),
      );
    }

    if (reducedP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/reduce.svg", data: reducedP),
      );
    }

    if (freeP != null) {
      children.add(
        Tarification(svgPath: "assets/svg/free.svg", data: freeP),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget buildSuggestedDay() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for(int index =1;index<=7;index++)...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = selectedDate.add(Duration(days:index- selectedDate.weekday));
                    intensity = getIntensity();
                  });
                },
                child: SuggestedDay(weekday: index,
                  title: getWeekday(index),
                  spot: widget.spot,
                  isSelected: selectedDate.weekday == index,),
              ),
            )
         ]
        ]
      ),
    );
  }
  Widget buildHighlights() {
    List<Widget> children = [];

    for (int i = 0; i < widget.spot.highlights.length; i++) {
      String h = widget.spot.highlights[i];
      children.add(Row(
        children: [
          const Icon(
            CupertinoIcons.check_mark,
            color: kPrimary,
          ),
          const SizedBox(width: kPadding5),
          Text(
            h,
            style: kRegularNunito16,
          )
        ],
      ));
    }

    return IntrinsicWidth(child: Column(children: children));
  }

  Widget buildOpenHours() {
    List<String> stringifiedHours = [];

    for (int i = 0; i < 7; i++) {
      List<Hours> hoursList = widget.spot.openHours[i].hours;

      /// Define the date for the weekday, based on today
      DateTime today = selectedDate;
      int currentWeekday = today.weekday;
      int targetWeekday = i + 1;
      int difference = targetWeekday - currentWeekday;
      DateTime targetDate = today.add(Duration(days: difference));

      /// Check if exceptional hours
      List<Hours>? exceptionalOpenHours = widget.spot.getExceptionalOpenHoursAt(targetDate.copyWith(hour: hour));
      if (exceptionalOpenHours != null) {
        hoursList = exceptionalOpenHours;
      }

      String str = "";
      for (int j = 0; j < hoursList.length; j++) {
        Hours hours = hoursList[j];

        if (hoursList.length > 1) {
          if (j > 0 || j == hoursList.length - 1) {
            str += "  ";
          }
        }

        str += "${hours.start.length < 5 ? "0" : ""}${hours.start}-${hours.end}";
      }
      stringifiedHours.add(str);
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Lundi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[0].contains(":") ? "Fermé" : stringifiedHours[0], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Mardi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[1].contains(":") ? "Fermé" : stringifiedHours[1], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Mercredi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[2].contains(":") ? "Fermé" : stringifiedHours[2], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Jeudi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[3].contains(":") ? "Fermé" : stringifiedHours[3], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Vendredi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[4].contains(":") ? "Fermé" : stringifiedHours[4], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Samedi", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[5].contains(":") ? "Fermé" : stringifiedHours[5], style: kRegularNunito16),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const SizedBox(width: 80, child: Text("Dimanche", style: kRegularNunito16)),
              const SizedBox(width: kPadding20),
              Text(!stringifiedHours[6].contains(":") ? "Fermé" : stringifiedHours[6], style: kRegularNunito16),
            ],
          ),
        ],
      ),
    );
  }
String getWeekday(weekday) {
  switch (weekday) {
    case 1:
      return "Lundi";
    case 2:
      return "Mardi";
    case 3:
      return "Mercredi";
    case 4:
      return "Jeudi";
    case 5:
      return "Vendredi";
    case 6:
      return "Samedi";
    case 7:
      return "Dimanche";
  }
  return "NA";
}

}
