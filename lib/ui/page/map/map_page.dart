import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/bloc/map/map_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/city_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/explore/region_page.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:hoora/ui/widget/playlist_card.dart';
import 'package:hoora/ui/widget/map/spot_marker.dart';
import 'package:hoora/ui/widget/map/spot_sheet.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  final MapController mapController = MapController();
  bool isCategoriesDisplayed = false;
  LatLng? userPosition;
  double zoom = 15;
  
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

    /// Update actual date
    Timer.periodic(const Duration(minutes: 1), (_) {
      DateTime date = DateTime.now();
      context.read<MapBloc>().add(UpdateDate(date: date));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is CitySelectedUpdated) {
          Region selectedRegion = context.read<MapBloc>().selectedRegion;
          City? selectedCity = context.read<MapBloc>().selectedCity;
          mapController.move(selectedCity == null ? selectedRegion.getLatLng() : selectedCity.getLatLng(), zoom);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: const Center(child: CircularProgressIndicator(color: kPrimary)),
          );
        }

        Region selectedRegion = context.read<MapBloc>().selectedRegion;
        City? selectedCity = context.read<MapBloc>().selectedCity;

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: selectedCity == null ? selectedRegion.getLatLng() : selectedCity.getLatLng(),
            initialZoom: zoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
          TileLayer(urlTemplate: context.read<MapBloc>().mapBoxUrl),
            MarkerLayer(
              markers: buildSpotMarkers(),
            ),

            /// User position marker
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
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
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
                      style: kRegularNunito14.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            /// Gem profile button
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(kPadding20),
                child: Align(alignment: Alignment.topRight, child: GemButton(isLight: true)),
              ),
            ),

            /// Buttons
            SafeArea(
                child: Padding(
              /// 25 = Gem button size
              padding: const EdgeInsets.only(left: kPadding20, top: kPadding20 + 25 + kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPlaylistButton(),
                  const SizedBox(height: kPadding10),
                  buildCenterPositionButton(),
                  const SizedBox(height: kPadding10),
                  buildRegionButton(),
                ],
              ),
            ))
          ],
        );
    }
    
    );
  }

  List<Marker> buildSpotMarkers() {
    List<Marker> markers = [];
    List<Spot> filteredSpots = context.read<MapBloc>().filteredSpots;

    for (Spot spot in filteredSpots) {
      markers.add(
        Marker(
          height: 85,
          width: 85,
          point: spot.getLatLng(),
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return SpotSheet(spot: spot, userPosition: userPosition);
                  },
                );
              },
              child: SpotMarker(spot: spot)),
        ),
      );
    }

    return markers;
  }

  Widget buildCenterPositionButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: kPrimary,
        border: Border.all(color: Colors.white, width: 2),
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
                Icons.gps_fixed,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlaylistButton() {
    Playlist? selectedPlaylist = context.read<MapBloc>().selectedPlaylist;
    List<Playlist> playlists = context.read<MapBloc>().playlists;

    late Widget button;

    if (selectedPlaylist == null || isCategoriesDisplayed) {
      button = Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: kPrimary,
          border: Border.all(color: Colors.white, width: 2),
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
              setState(() {
                isCategoriesDisplayed = !isCategoriesDisplayed;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(kPadding5),
              child: Center(
                child: SvgPicture.asset("assets/svg/playlist.svg"),
              ),
            ),
          ),
        ),
      );
    } else {
      button = PlaylistCard(
        playlist: selectedPlaylist,
        selectedPlaylist: selectedPlaylist,
        onTap: (_) {
          if (!isCategoriesDisplayed) {
            setState(() {
              isCategoriesDisplayed = true;
            });
          } else {
            Playlist? selectedPlaylist = context.read<MapBloc>().selectedPlaylist;
            if (selectedPlaylist != null && _.id == selectedPlaylist.id) {
              context.read<MapBloc>().add(PlaylistSelected(playlist: null));
            } else {
              context.read<MapBloc>().add(PlaylistSelected(playlist: _));
            }
            setState(() {
              isCategoriesDisplayed = false;
            });
          }
        },
      );
    }

    if (isCategoriesDisplayed) {
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
                  Playlist? selectedPlaylist = context.read<MapBloc>().selectedPlaylist;
                  if (selectedPlaylist != null && _.id == selectedPlaylist.id) {
                    context.read<MapBloc>().add(PlaylistSelected(playlist: null));
                  } else {
                    context.read<MapBloc>().add(PlaylistSelected(playlist: _));
                  }
                  setState(() {
                    isCategoriesDisplayed = false;
                  });
                },
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 50,
        child: Stack(
          children: [
            Padding(
              /// 20 the "half" of the button, to make the playlsit disappear behind it
              padding: const EdgeInsets.only(left: kPadding20 + 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: children,
                ),
              ),
            ),
            button,
          ],
        ),
      );
    }

    return button;
  }

  Widget buildRegionButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: kPrimary,
        border: Border.all(color: Colors.white, width: 2),
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
          onTap: () async {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
            MapBloc bloc = context.read<MapBloc>();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegionPage(
                  regions: bloc.regions,
                  selectedRegion: bloc.selectedRegion,
                  selectedCity: bloc.selectedCity,
                  onCitySelected: (region, city) {
                    bloc.add(RegionSelected(region: region, city: city));
                  },
                  onRegionSelected: (region) {
                    bloc.add(RegionSelected(region: region, city: null));
                  },
                ),
              ),
            );
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          },
          child: Padding(
            padding: const EdgeInsets.all(kPadding5),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/city.svg",
                height: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
