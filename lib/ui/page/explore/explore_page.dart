import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/explore/create_crowd_report_page.dart';
import 'package:hoora/ui/page/explore/filter_page.dart';
import 'package:hoora/ui/page/explore/spot_validation_page.dart';
import 'package:hoora/ui/page/explore/validation_success.dart';
import 'package:hoora/ui/widget/explore/hour_slider.dart';
import 'package:hoora/ui/widget/explore/spot_card.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:hoora/ui/widget/playlist_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:hoora/bloc/user/user_bloc.dart' as user_bloc;
import '../../../bloc/first_launch/first_launch_bloc.dart';
import '../../../model/city_model.dart';
import '../../../model/region_model.dart';
import '../../../tools.dart';
import '../../widget/map/spot_marker.dart';
import '../../widget/map/spot_sheet.dart';
import '../spot_page.dart';

class ExplorePage extends StatefulWidget {
  final Function(bool) changeBottomNavDisplay;
  const ExplorePage({super.key,required this.changeBottomNavDisplay});
  @override
  State<ExplorePage> createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PanelController _panelController = PanelController();
  bool isSuggestionShowed = false;
  var defaultPanelState = PanelState.OPEN;
  bool isMapShowed = false;
  LatLng? userPosition;
  late LatLng initialCenter;
  double zoom = 15;
  StreamSubscription<Position>? positionStream;
  String dayName = "";
  var panelRadius =  const BorderRadius.vertical(top:Radius.circular(0));
  bool firstTime = true;
  List<dynamic> suggestSearch = [];

  @override
  void initState() {
    super.initState();
    context.read<user_bloc.UserBloc>().add(user_bloc.Init());
    context.read<FirstLaunchBloc>().add(RequestGeolocation());
    positionStream = Geolocator.getPositionStream().listen((Position? position) {
      if (position != null && mounted) {
        final newPosition = LatLng(position.latitude, position.longitude);
        if(firstTime && context.read<ExploreBloc>().regions.isNotEmpty){
          var closestRegion = Tools.findClosestRegion(context.read<ExploreBloc>().regions,newPosition);
          context.read<ExploreBloc>().add(SelectRegionByPosition(region: closestRegion));
          debugPrint("closestRegion is ${closestRegion.name}");
          firstTime = false;
        }
        if (userPosition?.latitude.toStringAsFixed(4) != newPosition.latitude.toStringAsFixed(4) && userPosition?.longitude.toStringAsFixed(4) != newPosition.longitude.toStringAsFixed(4)) {
          setState(() {
            debugPrint('La géolocalisation a changé.\n- old = ${userPosition?.latitude.toStringAsFixed(4)}, ${userPosition?.longitude.toStringAsFixed(4)}\n- new = ${newPosition.latitude.toStringAsFixed(4)}, ${newPosition.longitude.toStringAsFixed(4)}\n________');
            userPosition = newPosition;
          });
        } else {

          debugPrint('La géolocalisation est la même.\n- old = ${userPosition?.latitude.toStringAsFixed(4)}, ${userPosition?.longitude.toStringAsFixed(4)}\n- new = ${newPosition.latitude.toStringAsFixed(4)}, ${newPosition.longitude.toStringAsFixed(4)}\n________');
        }
      }
    });
    mapController.mapEventStream.listen((event) {
      debugPrint("SALAM mapEventStream");

      if (event is MapEventMoveEnd ) {//|| event is MapEventRotateEnd
        setState(() {
          initialCenter = mapController.center;
          zoom = mapController.zoom;
        });
      }
    });
    scrollController.addListener((){
      FocusManager.instance.primaryFocus!.unfocus();
    });
  }


  void zoomInSpot(latlng){
    setState(() {
      isMapShowed = true;
      _panelController.close();
      defaultPanelState = PanelState.CLOSED;
      initialCenter = latlng;
      zoom = 17;
    });
  }
  void updateView2(){
    debugPrint("salam updateView2:${context.read<ExploreBloc>().filteredSpots.length}");
    context.read<ExploreBloc>().add(HourSelected(hour: context.read<ExploreBloc>().selectedDate.hour));
  }
  void updateView(GetSpotsSuccess state){
    debugPrint("salam filteredSpots:${context.read<ExploreBloc>().filteredSpots.length}");
    Region selectedRegion = context.read<ExploreBloc>().selectedRegion;
    City? selectedCity = context.read<ExploreBloc>().selectedCity;

    if(state.doesFind){
      isSuggestionShowed = false;

      if(!state.isSelectedBySpot && state.searchText.isNotEmpty){
        searchController.text = state.searchText;
      }
      if(!isMapShowed){
        defaultPanelState = PanelState.OPEN;
        _panelController.open();
      }else{
        defaultPanelState = PanelState.CLOSED;
        _panelController.close();
      }
    }else{
      searchController.clear();
    }
    if(state.applyZooming){
      setState(() {
        zoom = 15;
        initialCenter=context.read<ExploreBloc>().spots.length==1? context.read<ExploreBloc>().spots[0].getLatLng() :selectedCity == null ? selectedRegion.getLatLng() : selectedCity.getLatLng();
      });
      mapController.move(LatLng(initialCenter.latitude, initialCenter.longitude), zoom);
    }
    debugPrint("SALAM updateView");

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: kBackground2,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ExploreBloc, ExploreState>(
        listener: (context, state) {
          if (state is InitFailed) {
            Alert.showError(context, state.exception.message);
          }
          if (state is GetSpotsSuccess) {
            Region selectedRegion = context.read<ExploreBloc>().selectedRegion;
            City? selectedCity = context.read<ExploreBloc>().selectedCity;
            if(state.applyZooming){
              zoom = 15;
              initialCenter=context.read<ExploreBloc>().spots.length==1? context.read<ExploreBloc>().spots[0].getLatLng() :selectedCity == null ? selectedRegion.getLatLng() : selectedCity.getLatLng();
              mapController.move(LatLng(initialCenter.latitude, initialCenter.longitude), zoom);
            }
            debugPrint("SALAM1");

            if(state.doesFind){
              isSuggestionShowed = false;

              if(!state.isSelectedBySpot && state.searchText.isNotEmpty){
                searchController.text = state.searchText;
              }
              if(!isMapShowed){
                defaultPanelState = PanelState.OPEN;
                _panelController.open();
              }else{
                defaultPanelState = PanelState.CLOSED;
                _panelController.close();
              }
            }else{
              searchController.clear();
            }
          }
          if(state is GetSuggestionsSuccess ){
            suggestSearch = state.suggestion;
            isSuggestionShowed = true;
          }
          if (state is GetSpotsFailed) {
            Alert.showError(context, state.exception.message);
          }
          if (state is SuggestionEmptied) {
            debugPrint("haaaaaaaaaaaaay");
            setState(() {
              isSuggestionShowed = false;
            });
            if(!isMapShowed){
              defaultPanelState = PanelState.OPEN;
            }else{
              defaultPanelState = PanelState.CLOSED;
            }
          }
        },
        builder: (context, state) {
          if (state is InitLoading || state is InitFailed) {
            return const Center( child: CircularProgressIndicator(color: kPrimary));
          }
          return Scaffold(
            backgroundColor: kBackground2,
            resizeToAvoidBottomInset: false,
            body:Column(
              children: [
                Padding(
                  padding:  const EdgeInsets.fromLTRB(kPadding20,kPadding20,kPadding20,kPadding20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Visitez en \nheures creuses !",
                        style: kBoldARPDisplay18,
                      ),
                       Expanded(child: GestureDetector(
                           onTap: ()  {
                             SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                             Navigator.pushNamed(context, "/home/earnings");
                           },
                           child: Container(color:kBackground2,alignment: Alignment.centerRight,child: GemButton(isLight: true,bigGem: true,isExplore: true,)))),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding10),
                ///search
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Center(child: Image.asset("assets/images/searchbar.png",fit: BoxFit.fill,height: 50,width: 500)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if(searchController.text.isEmpty){
                                      context.read<ExploreBloc>().add(SearchSpots(search: searchController.text));
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      setState(() {
                                        isSuggestionShowed = false;
                                      });
                                    }
                                  },
                                  child: const SizedBox(width: 40,
                                      child: Icon(Icons.search, color: kPrimary))),
                              Expanded(
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  controller: searchController,
                                  onChanged: (text){
                                    if(text.isNotEmpty){
                                      Future.delayed(const Duration(milliseconds: 450), () {
                                        debugPrint("omad shod");
                                        if (!mounted) return;
                                        if(searchController.text.isNotEmpty && text == searchController.text){
                                          context.read<ExploreBloc>().add(GetSuggestions(search:searchController.text));
                                        }
                                      });
                                    }else{
                                      debugPrint("khali shod");
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        debugPrint("Future.delayed");

                                        if(searchController.text.isEmpty){
                                          debugPrint("khali hast");
                                          //FocusManager.instance.primaryFocus?.unfocus();
                                          context.read<ExploreBloc>().add(EmptySuggestions());
                                        }
                                      });
                                      // Future.delayed(const Duration(milliseconds: 600), () {
                                      //   if(searchController.text.isEmpty){
                                      //     FocusManager.instance.primaryFocus?.unfocus();
                                      //     context.read<ExploreBloc>().add(SearchSpots(search: ""));
                                      //   }
                                      // });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if(value.isEmpty){
                                      context.read<ExploreBloc>().add(SearchSpots(search: searchController.text));
                                      FocusManager.instance.primaryFocus!.unfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher ville, spot',
                                    border: InputBorder.none,
                                    hintStyle: kRegularNunito14.copyWith(color: const Color(0xffA0A0A0)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      FilterPage(
                                        selectedDate: context.read<ExploreBloc>().selectedDate,
                                        zone: context.read<ExploreBloc>().zone,
                                        sortingType: context.read<ExploreBloc>().sortingType,
                                        openSpots: context.read<ExploreBloc>().openSpots,
                                        onSubmit: (date,zone,sortingType,openSpots) {
                                          context.read<ExploreBloc>().add(FilterSelected(date: date, sortingType: sortingType,zone: zone, openSpots: openSpots));
                                        },
                                      ),
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Color(0x1A000000),
                                          offset: Offset(0,4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32))),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8,),
                                      Text(
                                        _getWeekday(context.read<ExploreBloc>().selectedDate),
                                        style: const TextStyle(color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const SizedBox(width: 8,),
                                      Image.asset("assets/images/equalizer.png", width: 16,),
                                      const SizedBox(width: 8,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if(isSuggestionShowed)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.topCenter,
                      color: kBackground2,
                      child: ListView.builder(
                          itemCount: suggestSearch.length,
                          itemBuilder: (itemBuilder,index) {
                            return GestureDetector(
                              onTap: (){
                                FocusManager.instance.primaryFocus!.unfocus();
                                setState(() {
                                  isSuggestionShowed = false;
                                });
                                if(suggestSearch[index] is Spot){
                                  searchController.text = (suggestSearch[index] as Spot).name;
                                  context.read<ExploreBloc>().add(SpotSelected(spot: suggestSearch[index] as Spot));
                                }else{
                                  var selectedCity = (suggestSearch[index] as City);
                                  searchController.text = selectedCity.name;
                                  context.read<ExploreBloc>().add(CitySelected(city: selectedCity));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,8.0,8.0,10.0),
                                child: Row(
                                  children: [
                                    //const Icon(Icons.search),
                                    suggestSearch[index] is Spot?Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                      child: SvgPicture.asset("assets/svg/Lieuxdinterets.svg",width: 24,height: 24,),
                                    ):const Icon(size: 24,Icons.location_city_sharp,color: kPrimary,),
                                    // Icon(suggestSearch[index] is Spot?Icons.place:Icons.location_city),
                                    const SizedBox(width: kPadding20,),
                                    Text(suggestSearch[index] is Spot?(suggestSearch[index] as Spot).name:(suggestSearch[index] as City).name,
                                      style: kRegularNunito14.copyWith(fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                else
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: kPadding10),
                      /// Should be reworked with a paint class.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                        child: HourSlider(
                            initialHour: context
                                .read<ExploreBloc>()
                                .selectedDate
                                .hour,
                            onChangedEnd: (hour) {
                              context.read<ExploreBloc>().add(HourSelected(hour: hour));
                            }),
                      ),
                      const SizedBox(height: kPadding10),
                      /// Playlists
                      Builder(builder: (context) {
                        List<Playlist> playlists = context.read<ExploreBloc>().playlists;
                        Playlist? selectedPlaylist = context.read<ExploreBloc>().selectedPlaylist;

                        List<Widget> children = [];
                        for (int i = 0; i < playlists.length; i++) {
                          Playlist playlist = playlists[i];
                          EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10);

                          if (i == 0) {
                            padding = const EdgeInsets.only(left: 20, right: 10);
                          }

                          if (i == playlists.length - 1) {
                            padding = const EdgeInsets.only(right: 20);
                          }

                          children.add(
                            Padding(
                              padding: padding,

                              /// For the shadow.
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: PlaylistCard(
                                  playlist: playlist,
                                  selectedPlaylist: selectedPlaylist,
                                  onTap: (_) {
                                    Playlist? selectedPlaylist =
                                        context
                                            .read<ExploreBloc>()
                                            .selectedPlaylist;
                                    if (selectedPlaylist != null &&
                                        _.id == selectedPlaylist.id) {
                                      context
                                          .read<ExploreBloc>()
                                          .add(PlaylistSelected(playlist: null));
                                    } else {
                                      context
                                          .read<ExploreBloc>()
                                          .add(PlaylistSelected(playlist: _));
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 60,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: children,
                            ),
                          ),
                        );
                      }),

                      /// Spot cards
                      Expanded(
                        child: Stack(
                          children: [
                            if(isMapShowed) map(),
                            SlidingUpPanel(
                              defaultPanelState: defaultPanelState,
                              color: kBackground2,
                              controller: _panelController,
                              onPanelOpened: () {
                                setState(() {
                                  isMapShowed = false;
                                });
                                widget.changeBottomNavDisplay(false);
                              },
                              onPanelClosed: () {
                                widget.changeBottomNavDisplay(true);
                              },
                              borderRadius:isMapShowed ?const BorderRadius.vertical(top:Radius.circular(24)):const BorderRadius.vertical(top:Radius.circular(0)),
                              minHeight: 70,
                              maxHeight: MediaQuery.of(context).size.height * 0.7, // How much the panel can be dragged up
                              panel: isMapShowed ?Container():_buildSpotList(), // The content of the panel (spot list)
                              collapsed: _buildCollapsedHook(), // The drag hook at the bottom
                              body:  const Center(), // Optional: The content behind the sliding panel (the map is here)
                            ),
                            !isMapShowed?Container(
                              margin: const EdgeInsets.all(16.0),
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                  onTap: (){
                                    isMapShowed = true;
                                    _panelController.close();
                                  },
                                  child: Container(
                                    width: 65,
                                    height: 61,
                                    decoration:  BoxDecoration(
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
                                    child:  Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(Icons.map,color: kBlackGreen,),
                                          Text("Carte",style: kRegularNunito14.copyWith(fontWeight: FontWeight.w700),)
                                        ],
                                      ),
                                    ),
                                  )),
                            ):Container(),
                          ],
                        ),
                      ),
                    ],
                  ))

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollapsedHook() {
    return Container(
      decoration: const BoxDecoration(
        color: kBackground2,
        borderRadius: BorderRadius.vertical(top:Radius.circular(24))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: kBlackGreen,
              borderRadius: BorderRadius.circular(12),),
            ),
          Column(
            children: [
              Text(
                "Consultez la liste des spots",
                style: kRegularNunito16.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          )
        ]),
      );
  }

  Widget _buildSpotList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: ListView.builder(
          controller: scrollController,
          itemCount: context.read<ExploreBloc>().filteredSpots.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            EdgeInsetsGeometry padding =
            const EdgeInsets.only(bottom: 18);
            Spot spot = context.read<ExploreBloc>().filteredSpots[index];

            if (index == 0) {
              padding = const EdgeInsets.only(top: 10, bottom: 18);
            }

            if(index == context.read<ExploreBloc>().filteredSpots.length-1){
              padding = const EdgeInsets.only(top: 10, bottom: 200);
            }

            return Container(
              margin: padding,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpotPage(
                        spot: spot,
                        userPosition: userPosition,
                      ),
                    ),
                  );
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => ValidationSuccessOrAlreadyPage(userPosition: LatLng(-1, -1), spot: spot),
                  //   ),);
                  // });
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => SpotValidationPage(spots: context.read<ExploreBloc>().spots.getRange(0, 30).toList(), userPosition: LatLng(-1, -1)),
                  //   ),);
                  // });
              },child: SpotCard(spot: spot)),
            );
          }),
    );
  }

  Widget map(){
    return GestureDetector(
      onPanDown: (details) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: zoom,
          maxZoom: 30,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
        ),
        children: [
          TileLayer(
              urlTemplate: context.read<ExploreBloc>().mapBoxUrl,
              additionalOptions: const {
                'accessToken': 'YOUR_MAPBOX_ACCESS_TOKEN'
              },
          ),

          MarkerLayer(markers: buildSpotMarkers()),

          MarkerLayer(
            markers: [
              if (userPosition != null)
                Marker(
                  point: userPosition!,
                  height: 25,
                  width: 25,
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(kRadius100),
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ),
            ],
          ),

          buildPositionButton(),
          mapText(context.read<ExploreBloc>().selectedDate),
          BlocConsumer<FirstLaunchBloc, FirstLaunchState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state is GeolocationForeverDenied)
                        // Container(
                        //   padding: const EdgeInsets.only(
                        //       left: 15, right: 15, top: 15, bottom: 10),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFCECAFF),
                        //     borderRadius: BorderRadius.circular(kRadius10),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "Veuillez autoriser la localisation pour découvrir les lieux autour de vous et valider vos visites en heure creuse.",
                        //         style: kRegularNunito16.copyWith(
                        //           color: kDarkBackground,
                        //         ),
                        //         textAlign: TextAlign.left,
                        //       ),
                        //       const SizedBox(height: 5),
                        //       ElevatedButton(
                        //         onPressed: () => AppSettings.openAppSettings(),
                        //         style: ElevatedButton.styleFrom(
                        //           elevation: 1,
                        //           backgroundColor: const Color(0xFFC5F8DC),
                        //           shape: const StadiumBorder(),
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 20, vertical: 10),
                        //           minimumSize: Size.zero,
                        //         ),
                        //         child: Text(
                        //           "Ouvrir les réglages",
                        //           style: kBoldNunito16.copyWith(
                        //               color: kDarkBackground),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      if (state is! GeolocationForeverDenied)
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(
                              kRadius10,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kPadding10),
                            child: Text(
                              "Consultez les dernières affluences signalées\nChoisissez un site et validez votre visite !",
                              style: kRegularNunito14.copyWith(
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  List<Marker> buildSpotMarkers() {
    List<Marker> markers = [];
    List<Spot> filteredSpots = context.read<ExploreBloc>().filteredSpots;
    final superTypes = context.read<ExploreBloc>().superTypes;
    for (Spot spot in filteredSpots) {
      markers.add(
        Marker(
          height: 80,
          width: 80,
          point: spot.getLatLng(),
          child: SpotMarker(spot: spot,imageCode: spot.superTypeImagePath(superTypes),selectedDate: context.read<ExploreBloc>().selectedDate, clicked: () {
            if(context.read<ExploreBloc>().selectedDate.hour==DateTime.now().hour){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SpotSheet(spot: spot, userPosition: userPosition,selectedDate: context.read<ExploreBloc>().selectedDate,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            }else{
              positionStream!.pause();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SpotPage(spot: spot,userPosition: userPosition,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            }
          },),
        ),
      );
    }

    return markers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(positionStream!=null){
      if(positionStream!.isPaused){
        positionStream!.resume();
      }
    }
  }

  Widget buildPositionButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.fromLTRB(0,kPadding10,kPadding10,0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kPadding10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kRadius10),
            onTap: () {
              if (userPosition != null) {
                mapController.move(userPosition!, zoom);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(kPadding5),
              child: Center(
                child: Icon(
                  size: 24,
                  Icons.near_me,
                  color: kBlackGreen,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mapText(DateTime selectedDate) {
    return selectedDate.hour==DateTime.now().hour?Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(kPadding10),
        child: Text("En ce moment :",style: kBoldNunito12.copyWith(fontStyle: FontStyle.italic),),
      ),
    ):Container();
  }

  String _getWeekday(DateTime date) {
    DateTime today = DateTime.now();
    if (date.day == today.day) {
      return "Aujourd'hui";
    } else if (date.day == today.day + 1) {
      return "Demain";
    }
    return date.getWeekday();
  }

  @override
  bool get wantKeepAlive => true;
}
