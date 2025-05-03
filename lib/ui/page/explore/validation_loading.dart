import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/explore/spot_validation_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import '../../../bloc/nearby_spots_loading/nearby_spots_loading_bloc.dart';
import '../../../common/alert.dart';
import '../../../tools.dart';

class ValidationLoading extends StatefulWidget {


  const ValidationLoading({super.key});

  @override
  State<ValidationLoading> createState() => _ValidationLoadingState();
}

class _ValidationLoadingState extends State<ValidationLoading> {
  StreamSubscription<Position>? positionStream;
  var firstTime = true;
  var loading = true;
  var doesGo = false;
  @override
  void initState() {
    super.initState();
    loading = true;
    doesGo = false;
    var firstTime = true;
    context.read<NearbySpotsLoadingBloc>().add(NearbySpotsLoading());
    Tools.enableLocation();
    positionStream = Geolocator.getPositionStream().listen((Position? position) {
      if (position != null && mounted) {
        final newPosition = LatLng(position.latitude, position.longitude);
        if(firstTime){
          context.read<NearbySpotsLoadingBloc>().add(SearchNearBySpots(userPosition: newPosition));
          firstTime=false;
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NearbySpotsLoadingBloc, NearbySpotsLoadingState>(
      listener: (context, state) {
        if (state is NearbySpotsLoadingFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is NearbySpotsLoaded) {
          if(state.spots.isNotEmpty){
            if(!doesGo){
              Future.delayed(const Duration(milliseconds: 1200),(){
                debugPrint("THDDD");
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => SpotValidationPage(
                    userPosition:state.pos, spots: state.spots,fromLoadingPage: true,
                  ),
                ),);
              });
              doesGo=true;
            }
          }else{
            Future.delayed(const Duration(seconds: 1),(){
              setState(() {
                loading = false;
              });
            });
          }
        }

        return Scaffold(
          backgroundColor: kPrimary,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(kPadding20,0,kPadding20,kPadding20,),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: kPadding40),
                    alignment: Alignment.centerLeft,
                    child: !loading?IconButton(
                      onPressed: () {
                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

                        Navigator.pop(context);
                      },
                      icon:  SvgPicture.asset("assets/svg/arrow_left_svg.svg",color: Colors.white,height: 22,width: 22,),
                    ):Container(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                        child: Text(
                          loading==true?"Chargement des spots à proximité !":"Rien à l’horizon !",
                          style: kBoldARPDisplay18.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40,),
                      ///Gif loading
                      loading==true?Lottie.asset(
                        height: 200,
                        "assets/animations/loading.json",
                      ):SizedBox(
                        height: 200,
                        child: Text(
                          "Aucun spot déjà référencé dans l'application n'est à proximité. Consultez la carte pour explorer autour de vous.",
                          style: kRegularBalooPaaji16.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  const SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
