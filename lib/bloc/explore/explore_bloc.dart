import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/local_storage.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/repository/spot_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/playlist_repository.dart';
import 'package:hoora/repository/region_repository.dart';
import 'package:hoora/repository/crowd_report_repository.dart';
import 'package:hoora/repository/super_type_repository.dart';
import 'package:latlong2/latlong.dart';

import '../../common/globals.dart';
import '../../model/super_type_model.dart';
part 'explore_event.dart';
part 'explore_state.dart';

enum ExploreMode { search,spot,city }

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final RegionRepository areaRepository;
  final SpotRepository spotRepository;
  final PlaylistRepository playlistRepository;
  final CrashRepository crashRepository;
  final CrowdReportRepository crowdReportRepository;
  final SuperTypeRepository superTypeRepository;
  ExploreMode mode = ExploreMode.search;
  LatLng? userPosition;
  late List<SuperType> superTypes;

  late List<Playlist> playlists;
  Playlist? selectedPlaylist;

  late List<Region> regions;
  late Region selectedRegion;
  City? selectedCity;
  Spot? selectedSpot;
  String searchText = "";

  /// can be all or rewarded spot
  String sortingType = "all";

  //rhe fourth filter in the filter page
  String zone = "city";

  bool applyZooming = true;

  /// openSpots = true => returns all open spots
  /// openSpots = false => returns all open or close spots
  bool openSpots = true;

  late DateTime selectedDate;

  /// All spots fetched from the db.
  List<Spot> spots = [];

  List<Spot> allSpots = [];

  /// Filtered spots (displayed)

  List<Spot> filteredSpots = [];

  late String mapBoxUrl = "https://api.mapbox.com/styles/v1/devhoora/clz8kwmcm002y01qt5jit5iul/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2aG9vcmEiLCJhIjoiY2x1bGMwcXQxMGpxNTJrbHcwMHlsb2FkMiJ9.QeSomxVwnjxWJBmmJA__FA";

  ExploreBloc({
    required this.playlistRepository,
    required this.spotRepository,
    required this.areaRepository,
    required this.crashRepository,
    required this.crowdReportRepository,
    required this.superTypeRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<PlaylistSelected>(playlistSelected);
    on<SearchSpots>(searchSpots);
    on<CitySelected>(citySelected);
    on<SpotSelected>(spotSelected);
    on<EmptySuggestions>((EmptySuggestions event, Emitter<ExploreState> emit)async{
      emit(SuggestionEmptied());
    });
    on<GetSuggestions>(returnSuggestions);
    on<SelectRegionByPosition>(selectRegionByPosition);
    on<FilterSelected>(filterSelected);
    on<HourSelected>(hourSelected);
  }

  void initialize(Init event, Emitter<ExploreState> emit) async {
    try {
      emit(InitLoading());
      await getActiveMapBoxUrl();
      List future = await Future.wait([
        playlistRepository.getPlaylists(),
        areaRepository.getAllRegions(),
        superTypeRepository.getAllSuperTypes(),
      ]);
      ///set all superTypes
      LocalStorage.saveSuperTypes(future[2]);
      superTypes = future[2];
      /// Set and sort playlists, based on priority order.
      playlists = future[0];
      playlists.sort((a, b) {
        return a.priority.compareTo(b.priority);
      });

      /// Default selected area
      regions = future[1];
      selectedRegion = regions[0];

      /// Set a static, used for spots,
      Region.allRegions = regions;

      /// Default selected day and hour
      selectedDate = DateTime.now();

      /// If after the opening time, set to the next day.
      if(selectedDate.hour>=22 || selectedDate.hour<6){
        selectedDate = selectedDate.add(const Duration(days: 1));
        selectedDate = selectedDate.copyWith(hour: 7);
      }

      /// Then fetch spots
      await _fetchSpots2(emit);
      emit(InitSuccess());
    } catch (exception) {
      /// Report crash to Crashlytics
      ////crashRepository.report(exception, stack);
      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  @override
  Future<void> close() {
    _searchSpotsSubscription?.cancel();
    _selectCitySubscription?.cancel();
    return super.close();
  }

  StreamSubscription<CityAndSpots>? _searchSpotsSubscription;
  int searchSpotCounter  = -1;

  StreamSubscription<List<Spot>>? _selectCitySubscription;
  int selectCityCounter  = -1;

  Future<void> _fetchSpots2(Emitter<ExploreState> emit) async {
    try{
      emit(SpotsLoading());
      _searchSpotsSubscription?.cancel();
      mode = ExploreMode.search;
      searchSpotCounter = -1;
      _searchSpotsSubscription = spotRepository.getSpotsBySearchStream(searchText, zone, regions,selectedRegion).listen((CityAndSpots res) {

        //finding city and region
        var cityName = "";
        if(searchText.isNotEmpty && selectedCity!=null){
          cityName = selectedCity!.name;
        }

        searchSpotCounter++;

        debugPrint("New data received _fetchSpots2: ${res.spots.length} spots");
        if(res.spots.isNotEmpty){
          if(mode == ExploreMode.spot && selectedSpot !=null){
            for (Spot spot in res.spots){
              if(spot.id==selectedSpot!.id){
                applyZooming =false;
                selectedSpot = spot;
                spotSelectedFromStream(selectedSpot!, emit);
              }
            }
            if (emit.isDone) return;
          }
          spots = res.spots;
          if(searchSpotCounter>0){
            _mapSpots(res);
          }else{
            _filterSpots();
          }
        }

        AppConstants.explorePageKey.currentState!.updateView(GetSpotsSuccess(searchText: cityName,doesFind: res.spots.isNotEmpty,applyZooming: applyZooming));
        emit(GetSpotsSuccess(searchText: cityName,doesFind: res.spots.isNotEmpty,applyZooming: applyZooming));
        applyZooming = true;
      });
    }catch(e, stackTrace) {
      debugPrint("Error fetching spots: ${e.toString()}");
      debugPrint("Stack Trace: $stackTrace");
      emit(GetSpotsFailed(exception: AlertException.fromException(e)));
    }
  }

  void searchSpots(SearchSpots event, Emitter<ExploreState> emit) async {
    searchText = event.search;
     _fetchSpots2(emit);
  }

  void playlistSelected(PlaylistSelected event, Emitter<ExploreState> emit) async {
    selectedPlaylist = event.playlist;
    _filterSpots();
    emit(InitSuccess());
  }

  void selectRegionByPosition(SelectRegionByPosition event, Emitter<ExploreState> emit) async {
    selectedRegion = event.region;
    _fetchSpots2(emit);
  }
  void filterSelected(FilterSelected event, Emitter<ExploreState> emit) async {
    selectedDate = event.date.copyWith(hour: selectedDate.hour, minute: 00);
    sortingType = event.sortingType;
    openSpots = event.openSpots;
    if(zone!=event.zone){
      zone = event.zone;
      applyZooming = false;
      _fetchSpots2(emit);
    }else{
      _filterSpots();
    }
    emit(InitSuccess());
  }

  void citySelected(CitySelected event, Emitter<ExploreState> emit) async {
    mode = ExploreMode.city;
    searchText = event.city.name;
    zone="city";
    for(Spot spot in spots){
      if(spot.cityId==event.city.id){
        var regId  = spot.regionId;
        for(Region r in regions){
          if(r.id==regId){
            selectedRegion = r;
          }
          break;
        }
        break;
      }
    }

    selectedCity = event.city;
    applyZooming =true;
    _fetchSpots2(emit);
  }

  void spotSelected(SpotSelected event, Emitter<ExploreState> emit) async {
    try {
      debugPrint("spotSelected running");
      mode = ExploreMode.spot;
      emit(SpotsLoading());
      searchText = event.spot.cityName;
      spots.clear();
      spots.add(event.spot);
      selectedSpot = spots[0];
      for(Region r in regions){
        for(City c in r.cities){
          if(c.id==event.spot.cityId){
            selectedRegion = r;
            selectedCity = c;
            break;
          }
        }
      }
      _filterSpots();
      emit(GetSpotsSuccess(searchText: event.spot.name,doesFind: true,isSelectedBySpot: true,applyZooming: true));
      if (emit.isDone) return;
    } catch (error) {
      AlertException alertException = AlertException.fromException(error);
      if (emit.isDone) return;
      debugPrint("Error spotSelected: ${error.toString()}");
      emit(GetSpotsFailed(exception: alertException));
    }
    emit(InitSuccess());
  }

  void spotSelectedFromStream(Spot spot,Emitter<ExploreState> emit) async {
    try {
      debugPrint("spotSelectedFromStream running");
      mode = ExploreMode.spot;
      searchText = spot.cityName;
      spots.clear();
      spots.add(spot);
      selectedSpot = spots[0];
      for(Region r in regions){
        for(City c in r.cities){
          if(c.id==spot.cityId){
            selectedRegion = r;
            selectedCity = c;
            break;
          }
        }
      }
      _filterSpots();
      if (emit.isDone) return;
      //AppConstants.explorePageKey.currentState!.updateView(GetSpotsSuccess(searchText: spot.name,doesFind: true,isSelectedBySpot: true));
      emit(GetSpotsSuccess(searchText: spot.name,doesFind: true,isSelectedBySpot: true,applyZooming: false));
    } catch (error) {
      AlertException alertException = AlertException.fromException(error);
      debugPrint("Error spotSelected: ${error.toString()}");
    }
  }

  void hourSelected(HourSelected event, Emitter<ExploreState> emit) async {
    selectedDate = selectedDate.copyWith(hour: event.hour);
    _filterSpots();
    emit(InitSuccess());
  }


  void _filterSpots() {
    debugPrint("filtering spots");
    filteredSpots = [];

    /// Unique filtering case for "Top" playlist.
    if (selectedPlaylist != null && selectedPlaylist!.name.toLowerCase().contains("top")) {
      for (int i = 0; i < spots.length; i++) {
        Spot spot = spots[i];
        if (!spot.isClosedAt(selectedDate)) {
          filteredSpots.add(spot);
        }
      }
      //sortByScore
      filteredSpots.sort((a, b) {
        return b.score.compareTo(a.score);
      });

      filteredSpots = filteredSpots.take(20).toList();
      return;
    }

    /// Standard playlist filtering. and adding spots
    List<Spot> closedSpot = [];
    for (Spot spot in spots) {
      if(spot.hasPlaylist(selectedPlaylist)){
        if(sortingType=="all"){
          if(openSpots){
            if(!spot.isClosedAt(selectedDate)){
              filteredSpots.add(spot);
            }
          }else{
            if(!spot.isClosedAt(selectedDate)){
              filteredSpots.add(spot);
            }else{
              closedSpot.add(spot);
            }
          }
        }else if(sortingType=="rewarded"){
          if(spot.getGemsAt(selectedDate) > 0 && !spot.isClosedAt(selectedDate)){
            filteredSpots.add(spot);
          }
        }
      }
    }

    /// Descending order sorting by gems or scores
    filteredSpots.sort((a, b) {
      int aGems = a.getGemsAt(selectedDate);
      int bGems = b.getGemsAt(selectedDate);

      /// Compare score if same amount of gems
      if (aGems == bGems) {
        return b.score.compareTo(a.score);
      }

      return bGems.compareTo(aGems);
    });
    filteredSpots.addAll(closedSpot);
  }

  void _mapSpots(res){
    debugPrint("Mapping spots");
    Map<String, Spot> spotMap = {for (var spot in filteredSpots) spot.id: spot};

    for (Spot newSpot in res) {
      spotMap[newSpot.id] = newSpot; // Add or update
    }

    filteredSpots = spotMap.values.toList();
  }

  Future<void> getActiveMapBoxUrl() async {
    try {
      final url = await AppConstants.getMapBoxUrl();
      mapBoxUrl = url;
    } catch (error) {
      print(error);
    }
  }

  void returnSuggestions(GetSuggestions event, Emitter<ExploreState> emit) async {
    var suggestionList = [];
    if(event.search.isNotEmpty){
      var suggestionSpots = await spotRepository.get5SpotSuggestion(event.search);
      var suggestionCities = [];
      for(Region region in regions){
        for(City city in region.cities){
          if(city.name.toLowerCase().contains(event.search.toLowerCase())){
            suggestionCities.add(city);
            if(suggestionCities.length==5){
              break;
            }
          }
        }
      }
      suggestionList.addAll(suggestionCities);
      suggestionList.addAll(suggestionSpots);
    }
    emit(GetSuggestionsSuccess(suggestion: suggestionList));
  }
}
