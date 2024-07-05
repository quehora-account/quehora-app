import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/extension/weekday_extension.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/ui/page/explore/date_page.dart';
import 'package:hoora/ui/page/explore/region_page.dart';
import 'package:hoora/ui/widget/gem_button.dart';
import 'package:hoora/ui/widget/explore/hour_slider.dart';
import 'package:hoora/ui/widget/playlist_card.dart';
import 'package:hoora/ui/widget/explore/spot_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ExploreBloc, ExploreState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is GetSpotsFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: kPadding20, right: kPadding20),
              child: Align(alignment: Alignment.topRight, child: GemButton()),
            ),
            const SizedBox(height: kPadding20),
            const Padding(
              padding: EdgeInsets.only(left: kPadding20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Visitez en heures\ncreuses et gagnez\ndes Diamz !",
                  style: kBoldARPDisplay18,
                ),
              ),
            ),
            const SizedBox(height: kPadding20),
            Padding(
              padding: const EdgeInsets.only(left: kPadding20),
              child: Row(
                children: [
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: () {
                        ExploreBloc bloc = context.read<ExploreBloc>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegionPage(
                              regions: bloc.regions,
                              selectedRegion: bloc.selectedRegion,
                              selectedCity: bloc.selectedCity,
                              onCitySelected: (region, city) {
                                context.read<ExploreBloc>().add(RegionSelected(region: region, city: city));
                              },
                              onRegionSelected: (region) {
                                context.read<ExploreBloc>().add(RegionSelected(region: region, city: null));
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                        child: Text(
                          context.read<ExploreBloc>().selectedCity == null
                              ? context.read<ExploreBloc>().selectedRegion.name
                              : context.read<ExploreBloc>().selectedCity!.name,
                          style: kBoldNunito16.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: kPadding10),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      style: kButtonRoundedStyle,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DatePage(
                              selectedDate: context.read<ExploreBloc>().selectedDate,
                              onSelected: (date) {
                                context.read<ExploreBloc>().add(DateSelected(date: date));
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                        child: Text(
                          _getWeekday(context.read<ExploreBloc>().selectedDate),
                          style: kBoldNunito16.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kPadding20),

            /// Paddding is set in the widget, due to the Slider.
            /// Should be reworked with a paint class.
            HourSlider(
                initialHour: context.read<ExploreBloc>().selectedDate.hour,
                onChangedEnd: (hour) {
                  context.read<ExploreBloc>().add(HourSelected(hour: hour));
                }),
            const SizedBox(height: kPadding20),

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
                          Playlist? selectedPlaylist = context.read<ExploreBloc>().selectedPlaylist;
                          if (selectedPlaylist != null && _.id == selectedPlaylist.id) {
                            context.read<ExploreBloc>().add(PlaylistSelected(playlist: null));
                          } else {
                            context.read<ExploreBloc>().add(PlaylistSelected(playlist: _));
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
            Builder(builder: (context) {
              if (state is GetSpotsLoading) {
                return const Expanded(
                    child: Center(
                  child: CircularProgressIndicator(color: kPrimary),
                ));
              }
              List<Spot> filteredSpots = context.read<ExploreBloc>().filteredSpots;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: ListView.builder(
                      itemCount: filteredSpots.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);
                        Spot spot = filteredSpots[index];

                        if (index == 0) {
                          padding = const EdgeInsets.only(top: 20, bottom: 10);
                        }

                        if (index == filteredSpots.length - 1 && filteredSpots.length > 1) {
                          padding = const EdgeInsets.only(bottom: 20);
                        }

                        return Padding(
                          padding: padding,
                          child: SpotCard(spot: spot),
                        );
                      }),
                ),
              );
            }),
          ],
        );
      },
    );
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
